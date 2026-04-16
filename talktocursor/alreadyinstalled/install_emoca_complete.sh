#!/bin/bash
# EMOCA 완전 설치 스크립트
# 이 스크립트는 INSTALLATION_TROUBLESHOOTING.md에 문서화된 모든 문제점을 해결한 통합 설치 스크립트입니다.

set -e

# 설정
ENV_PATH="${ENV_PATH:-/mnt/sdb/JHW/envs/work38_cu11}"
CACHE_DIR="${CACHE_DIR:-/mnt/sdb/JHW/pip_cache}"
BUILD_DIR="${BUILD_DIR:-/mnt/sdb/JHW/build}"
TMP_DIR="${TMP_DIR:-/mnt/sdb/JHW/tmp}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PIP="${ENV_PATH}/bin/pip"
PYTHON="${ENV_PATH}/bin/python"

# 색상 출력
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 환경 확인
if [ ! -d "$ENV_PATH" ]; then
    log_error "Conda environment not found at $ENV_PATH"
    log_info "Please create the environment first:"
    log_info "  conda env create python=3.8 --file conda-environment_py38_cu11_ubuntu.yml"
    exit 1
fi

log_info "Using conda environment: $ENV_PATH"

# 디렉토리 생성
log_info "Creating directories..."
mkdir -p "$CACHE_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$TMP_DIR"

# 환경 변수 설정
export TMPDIR="$TMP_DIR"
export TEMP="$TMP_DIR"
export PYTHON_BUILD_TMPDIR="$TMP_DIR"

# pip 다운그레이드 (omegaconf 메타데이터 문제 해결)
log_info "Downgrading pip to 24.0 (for omegaconf compatibility)..."
$PIP install --cache-dir "$CACHE_DIR" pip==24.0

# Cython 먼저 설치
log_info "Installing Cython..."
$PIP install --cache-dir "$CACHE_DIR" --build "$BUILD_DIR" Cython==0.29.14

# requirements38.txt 수정본 생성 (flatbuffers 제거)
log_info "Preparing requirements38.txt (removing flatbuffers)..."
TEMP_REQUIREMENTS="${TMP_DIR}/requirements38_modified.txt"
grep -v "^flatbuffers" "${PROJECT_DIR}/requirements38.txt" > "$TEMP_REQUIREMENTS" || true

# requirements38.txt 설치
log_info "Installing packages from requirements38.txt..."
$PYTHON -m pip install --cache-dir "$CACHE_DIR" --build "$BUILD_DIR" \
    -r "$TEMP_REQUIREMENTS" || {
    log_warn "Some packages failed to install. Continuing with individual fixes..."
}

# 특정 버전으로 재설치 (호환성 문제 해결)
log_info "Fixing protobuf version (3.20.3)..."
$PIP install --cache-dir "$CACHE_DIR" --force-reinstall protobuf==3.20.3

log_info "Fixing numpy version (1.23.5)..."
$PIP install --cache-dir "$CACHE_DIR" --force-reinstall numpy==1.23.5

# PyTorch 확인
log_info "Checking PyTorch installation..."
PYTORCH_VERSION=$($PYTHON -c "import torch; print(torch.__version__)" 2>/dev/null || echo "NOT INSTALLED")
log_info "PyTorch version: $PYTORCH_VERSION"

if [[ "$PYTORCH_VERSION" != *"1.12.1"* ]]; then
    log_warn "PyTorch 1.12.1 not detected. Please install manually:"
    log_info "  mamba install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch"
fi

# PyTorch3D 0.7.2 설치 (precompiled wheel)
log_info "Installing PyTorch3D 0.7.2 (precompiled wheel)..."
$PIP uninstall -y pytorch3d 2>/dev/null || true
$PIP install --no-index --no-cache-dir pytorch3d==0.7.2 \
    -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1121/download.html || {
    log_error "PyTorch3D installation failed. Please check your PyTorch version."
    exit 1
}

# mediapipe 0.10.5 설치 (Python 3.8 호환)
log_info "Installing mediapipe 0.10.5 (Python 3.8 compatible)..."
$PIP uninstall -y mediapipe 2>/dev/null || true
$PIP install --cache-dir "$CACHE_DIR" mediapipe==0.10.5

# gdl 설치
log_info "Installing gdl package..."
cd "$PROJECT_DIR"
$PIP install --cache-dir "$CACHE_DIR" -e .

# 검증
log_info "Verifying installation..."

# Python 버전
PYTHON_VER=$($PYTHON --version 2>&1)
log_info "Python: $PYTHON_VER"

# PyTorch
if $PYTHON -c "import torch; print(f'PyTorch: {torch.__version__}, CUDA: {torch.cuda.is_available()}')" 2>/dev/null; then
    log_info "PyTorch: OK"
else
    log_error "PyTorch: FAILED"
fi

# PyTorch3D
if $PYTHON -c "import pytorch3d; print(f'PyTorch3D: {pytorch3d.__version__}')" 2>/dev/null; then
    log_info "PyTorch3D: OK"
else
    log_error "PyTorch3D: FAILED"
fi

# mediapipe
if $PYTHON -c "from mediapipe.python.solutions.face_mesh_connections import FACEMESH_CONTOURS; print('mediapipe OK')" 2>/dev/null; then
    log_info "mediapipe: OK"
else
    log_error "mediapipe: FAILED"
fi

# face_alignment API 수정 확인
log_info "Checking face_alignment API compatibility..."
if grep -q "LandmarksType._2D" "${PROJECT_DIR}/gdl/utils/FaceDetector.py" 2>/dev/null; then
    log_warn "face_alignment API needs to be updated:"
    log_warn "  Change LandmarksType._2D to LandmarksType.TWO_D in gdl/utils/FaceDetector.py line 84"
    log_warn "  See INSTALLATION_TROUBLESHOOTING.md Problem 10 for details"
fi

log_info "Installation complete!"
log_info "For detailed troubleshooting information, see INSTALLATION_TROUBLESHOOTING.md"

