# EMOCA 환경 구성 문제 해결 가이드

이 문서는 EMOCA 프로젝트의 환경 구성을 처음부터 끝까지 진행하면서 발생한 모든 문제점과 해결 방법을 상세하게 기록한 것입니다.

## 목차
1. [환경 개요](#환경-개요)
2. [초기 설정](#초기-설정)
3. [문제점 및 해결 방법](#문제점-및-해결-방법)
4. [최종 설치 명령어](#최종-설치-명령어)
5. [검증](#검증)

---

## 환경 개요

- **OS**: Linux 5.4.0-216-generic (Ubuntu)
- **Python**: 3.8.20
- **Conda 환경**: `work38_cu11` (경로: `/mnt/sdb/JHW/envs/work38_cu11`)
- **PyTorch**: 1.12.1+cu113
- **PyTorch3D**: 0.7.2 (precompiled wheel)
- **CUDA**: 11.3
- **디스크 공간 관리**: 모든 다운로드 및 임시 파일은 `/mnt/sdb/JHW`에 저장

---

## 초기 설정

### 설치 순서 (README Long version 기준)

1. **서브모듈 가져오기**
2. **Conda 환경 생성**
3. **환경 활성화**
4. **PyTorch 수동 설치** (환경 파일에서 주석 처리된 경우)
5. **Cython 설치**
6. **GDL 패키지 설치** (`pip install -e .`)
7. **Pytorch3D 설치 및 검증**

---

### 1. Conda 환경 생성

**중요:** Conda 환경을 특정 경로에 생성하려면 `conda create` 명령어를 사용하거나, conda의 `envs_dirs` 설정을 변경해야 합니다.

```bash
# 방법 1: conda 환경 파일 사용 (기본 위치)
conda env create python=3.8 --file conda-environment_py38_cu11_ubuntu.yml

# 또는 mamba 사용 (더 빠름)
mamba env create python=3.8 --file conda-environment_py38_cu11_ubuntu.yml

# 방법 2: 특정 경로에 환경 생성 (권장)
# 먼저 conda 환경 디렉토리 생성
mkdir -p /mnt/sdb/JHW/envs

# conda 환경을 특정 경로에 생성
conda create --prefix /mnt/sdb/JHW/envs/work38_cu11 python=3.8 --file conda-environment_py38_cu11_ubuntu.yml

# 또는 mamba 사용
mamba create --prefix /mnt/sdb/JHW/envs/work38_cu11 python=3.8 --file conda-environment_py38_cu11_ubuntu.yml
```

**참고:** 
- `conda-environment_py38_cu11_ubuntu.yml` 파일에서 PyTorch 관련 패키지는 주석 처리되어 있어야 합니다 (환경 생성 후 수동 설치).
- 환경 생성 시 PyTorch 버전 호환성 문제가 발생할 수 있으므로, PyTorch는 환경 생성 후 별도로 설치하는 것이 안전합니다.

### 2. PyTorch 설치

**중요:** `conda-environment_py38_cu11_ubuntu.yml` 파일에서 PyTorch 관련 패키지가 주석 처리되어 있다면, 환경 생성 후 수동으로 설치해야 합니다.

```bash
# 환경 활성화
conda activate work38_cu11
# 또는 직접 경로 사용
conda activate /mnt/sdb/JHW/envs/work38_cu11

# PyTorch 1.12.1 설치
mamba install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch

# 또는 prefix 사용 (환경이 특정 경로에 있는 경우)
mamba install --prefix /mnt/sdb/JHW/envs/work38_cu11 pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch
```

**설치 확인:**
```bash
/mnt/sdb/JHW/envs/work38_cu11/bin/python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA: {torch.version.cuda}')"
```

### 3. Cython 설치

```bash
# 환경 활성화 후
conda activate /mnt/sdb/JHW/envs/work38_cu11

# 또는 직접 경로 사용 (권장)
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install Cython==0.29.14
```

---

### 4. GDL 패키지 설치

```bash
# 프로젝트 디렉토리로 이동
cd /mnt/sdb/JHW/Projects/emoca

# GDL 패키지 설치 (editable mode)
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install -e .

# 또는 Python 직접 사용
/mnt/sdb/JHW/envs/work38_cu11/bin/python -m pip install -e .
```

---

### 5. Pytorch3D 설치

**방법 1: Facebook 공식 wheel 사용 (권장, 빠름)**

```bash
# 필수 의존성 먼저 설치
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install fvcore iopath

# Pytorch3D 0.7.2 설치 (precompiled wheel)
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install --no-index --no-cache-dir pytorch3d==0.7.2 \
    -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1121/download.html
```

**방법 2: 소스에서 컴파일 (README 권장, 시간 소요)**

```bash
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install git+https://github.com/facebookresearch/pytorch3d.git@v0.6.2
```

**설치 확인:**
```bash
/mnt/sdb/JHW/envs/work38_cu11/bin/python -c "import pytorch3d; print(f'Pytorch3D: {pytorch3d.__version__}')"
```

---

### 6. Submodules 가져오기

```bash
bash pull_submodules.sh
```

**주의:** 서브모듈 초기화 후 `git submodule status`로 상태를 확인하세요. `+` 표시가 있으면 서브모듈이 부모 저장소의 커밋과 다른 상태입니다.

**서브모듈 문제 해결:**
만약 서브모듈이 요구하는 커밋을 찾을 수 없는 경우 (예: `external/Deep3DFaceRecon_pytorch`), 현재 상태를 부모 저장소에 반영하거나 현재 상태로 진행할 수 있습니다:

```bash
# 서브모듈 상태 확인
git submodule status

# 서브모듈의 현재 상태를 부모 저장소에 반영 (권장)
cd external/Deep3DFaceRecon_pytorch
git add .
git commit -m "Update submodule to current state"
cd ../..

# 또는 spectre 서브모듈 내부의 서브모듈 문제 해결
cd external/spectre/external/face_detection
git add .
git commit -m "Update face_detection submodule"
cd ../../..
```

---

## 문제점 및 해결 방법

### 문제 1: ModuleNotFoundError: No module named 'omegaconf'

**증상:**
```
ModuleNotFoundError: No module named 'omegaconf'
```

**원인:**
- `requirements38.txt`의 패키지들이 자동으로 설치되지 않음
- `setup.py`의 `install_requires`가 주석 처리되어 있음

**해결:**
```bash
# conda 환경 활성화 확인
conda activate /mnt/sdb/JHW/envs/work38_cu11

# requirements38.txt 설치
/mnt/sdb/JHW/envs/work38_cu11/bin/python -m pip install -r requirements38.txt
```

---

### 문제 2: pip가 Python 2.7을 사용하는 문제

**증상:**
```
ERROR: Package 'GDL' requires a different Python: 2.7.18 not in '>=3.8'
ERROR: Could not find a version that satisfies the requirement omegaconf~=2.0.6
```

**원인:**
- Conda 환경이 활성화되지 않아 시스템의 Python 2.7 pip가 사용됨
- `pip install -e .` 실행 시 잘못된 Python 인터프리터 사용

**해결:**
```bash
# 방법 1: conda 환경 명시적 활성화
conda activate /mnt/sdb/JHW/envs/work38_cu11

# 방법 2: 직접 Python 경로 사용 (권장, 가장 확실함)
/mnt/sdb/JHW/envs/work38_cu11/bin/python -m pip install <package>

# GDL 설치 시에도 동일하게 적용
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install -e .

# 또는 Python 직접 사용
/mnt/sdb/JHW/envs/work38_cu11/bin/python -m pip install -e .
```

---

### 문제 3: pip 메타데이터 파싱 오류 (omegaconf)

**증상:**
```
WARNING: Ignoring version 2.0.6 of omegaconf since it has invalid metadata: 
Requested omegaconf~=2.0.6 ... has invalid metadata: .* suffix can only be used with == or != operators
```

**원인:**
- pip 24.1 이상 버전에서 `omegaconf 2.0.6`의 메타데이터를 파싱하지 못함

**해결:**
```bash
# pip 다운그레이드
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install pip==24.0

# 그 후 requirements38.txt 재설치
/mnt/sdb/JHW/envs/work38_cu11/bin/python -m pip install -r requirements38.txt
```

---

### 문제 4: Root 폴더 용량 부족

**증상:**
- pip 캐시와 빌드 파일이 root 폴더에 쌓여 디스크 공간 부족
- Conda 설치 중 `errno: 28` 오류 발생 (디스크 공간 부족)

**해결:**
모든 다운로드 및 임시 파일을 `/mnt/sdb/JHW`에 저장하도록 설정:

```bash
# 디렉토리 생성
mkdir -p /mnt/sdb/JHW/pip_cache
mkdir -p /mnt/sdb/JHW/build
mkdir -p /mnt/sdb/JHW/tmp

# 환경 변수 설정
export TMPDIR=/mnt/sdb/JHW/tmp
export TEMP=/mnt/sdb/JHW/tmp
export PYTHON_BUILD_TMPDIR=/mnt/sdb/JHW/tmp

# pip 설치 시 캐시 및 빌드 디렉토리 지정
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install \
    --cache-dir /mnt/sdb/JHW/pip_cache \
    --build /mnt/sdb/JHW/build \
    <package>

# Conda 캐시 정리 (필요 시)
conda clean --all

# Conda의 pkgs 디렉토리 변경 (선택사항)
# ~/.condarc 파일에 다음 추가:
# pkgs_dirs:
#   - /mnt/sdb/JHW/conda_pkgs
```

---

### 문제 5: flatbuffers와 mediapipe 의존성 충돌

**증상:**
```
ERROR: Cannot install -r requirements38.txt (line 17) and flatbuffers~=1.12 
because these package versions have conflicting dependencies.
```

**원인:**
- `flatbuffers~=1.12`와 `mediapipe`가 호환되지 않음
- `mediapipe`는 `flatbuffers>=2.0` 또는 `~=25.9`를 요구

**해결:**
`requirements38.txt`에서 `flatbuffers` 라인 제거 또는 주석 처리:

```python
# flatbuffers~=1.12  # Removed due to conflict with mediapipe
```

---

### 문제 6: protobuf 버전 호환성 문제

**증상:**
```
TypeError: Descriptors cannot be created directly. 
If this call came from a _pb2.py file, your generated code is out of date 
and must be regenerated with protoc >= 3.19.0. 
Downgrade the protobuf package to 3.20.x or lower.
```

**원인:**
- `protobuf` 버전이 너무 높음 (5.29.6)
- 일부 패키지가 구버전 protobuf를 요구

**해결:**
```bash
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install --cache-dir /mnt/sdb/JHW/pip_cache protobuf==3.20.3
```

---

### 문제 7: numpy 버전 호환성 문제

**증상:**
```
AttributeError: module 'numpy' has no attribute 'object'.
```

**원인:**
- `numpy 1.24.3`에서 `np.object`가 제거됨
- `onnx` 등이 구버전 numpy를 요구

**해결:**
```bash
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install --cache-dir /mnt/sdb/JHW/pip_cache numpy==1.23.5
```

---

### 문제 8: PyTorch3D libtorch_cuda_cu.so 오류

**증상:**
```
ImportError: libtorch_cuda_cu.so: cannot open shared object file: No such file or directory
```

**원인:**
- PyTorch 2.4.1이 설치되어 있었지만, PyTorch3D는 PyTorch 1.12.1용 라이브러리를 찾음
- PyTorch 버전 불일치

**해결:**
1. PyTorch를 1.12.1로 다운그레이드:
```bash
/mnt/sdb/JHW/envs/work38_cu11/bin/pip uninstall -y torch torchvision torchaudio
mamba install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch
```

2. PyTorch3D 0.7.2 precompiled wheel 설치 (소스 컴파일 대신):
```bash
# 먼저 필수 의존성 설치
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install fvcore iopath

# PyTorch3D 0.7.2 설치 (Facebook 공식 wheel)
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install --no-index --no-cache-dir pytorch3d==0.7.2 \
    -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1121/download.html
```

**중요:** 
- Python 버전(`py38`), CUDA 버전(`cu113`), PyTorch 버전(`pyt1121`)이 모두 일치해야 함
- 소스 컴파일은 시간이 오래 걸리고 문제가 발생할 수 있으므로 precompiled wheel 사용 권장
- README는 Pytorch3D 0.6.2를 권장하지만, 공식 wheel이 없어 0.7.2를 사용 (대부분 호환됨)

**Pytorch3D 0.7.2 호환성 주의사항:**
- `Textures`는 `pytorch3d.structures`에서 `pytorch3d.renderer`로 이동됨
- `TexturedSoftPhongShader`는 제거됨 (코드에서 사용하지 않으면 문제 없음)
- 대부분의 핵심 API는 호환됨 (Meshes, MeshRenderer, HardPhongShader 등)

---

### 문제 9: mediapipe Python 3.8 호환성 문제

**증상:**
```
TypeError: 'type' object is not subscriptable
File: .../mediapipe/tasks/python/components/containers/category.py, line 92
) -> list[Category]:
```

**원인:**
- `mediapipe 0.10.32`가 Python 3.9+를 요구
- Python 3.8에서는 `list[Category]` 같은 타입 힌트가 기본 지원되지 않음

**해결:**
```bash
# mediapipe를 Python 3.8과 호환되는 버전으로 다운그레이드
/mnt/sdb/JHW/envs/work38_cu11/bin/pip uninstall -y mediapipe
/mnt/sdb/JHW/envs/work38_cu11/bin/pip install --cache-dir /mnt/sdb/JHW/pip_cache mediapipe==0.10.5
```

**참고:** 
- `mediapipe 0.8.10`은 PyPI에서 더 이상 제공되지 않음
- `mediapipe 0.10.5`가 Python 3.8과 호환되는 최신 버전

---

### 문제 10: Conda 환경 생성 시 PyTorch 버전 호환성 오류

**증상:**
```
LibMambaUnsatisfiableError: Encountered problems while solving:
- package torchvision-0.11.3-py36_cpu requires pytorch 1.10.2, but none of the providers can be installed
```

**원인:**
- `conda-environment_py38_cu11_ubuntu.yml` 파일의 PyTorch 관련 패키지 버전이 호환되지 않음
- Conda가 자동으로 해결할 수 없는 의존성 충돌

**해결:**
`conda-environment_py38_cu11_ubuntu.yml` 파일에서 PyTorch 관련 라인을 주석 처리하고, 환경 생성 후 수동으로 설치:

```yaml
# PyTorch will be installed manually after environment creation
# - pytorch=1.12.1=py3.8_cuda11.3_cudnn8.3.2_0
# - torchvision=0.11.3
# - torchaudio=0.10.2
```

환경 생성 후:
```bash
mamba install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch
```

---

### 문제 11: face_alignment LandmarksType._2D 오류

**증상:**
```
AttributeError: _2D
File: .../gdl/utils/FaceDetector.py, line 239
self.model = face_alignment.FaceAlignment(face_alignment.LandmarksType._2D,
```

**원인:**
- `face_alignment` 라이브러리의 API 변경
- `LandmarksType._2D`가 더 이상 사용되지 않음
- 새로운 API에서는 `LandmarksType.TWO_D`를 사용해야 함

**해결:**
`gdl/utils/FaceDetector.py` 파일의 84번째 줄을 수정:

**수정 전:**
```python
self.model = face_alignment.FaceAlignment(face_alignment.LandmarksType._2D,
```

**수정 후:**
```python
self.model = face_alignment.FaceAlignment(face_alignment.LandmarksType.TWO_D,
```

**전체 수정된 코드:**
```python
self.model = face_alignment.FaceAlignment(face_alignment.LandmarksType.TWO_D,
                                          device=str(device),
                                          flip_input=self.flip_input,
                                          face_detector=self.face_detector,
                                          face_detector_kwargs=self.face_detector_kwargs)
```

---

## 최종 설치 명령어

전체 설치를 위한 통합 스크립트:

```bash
#!/bin/bash
set -e

# 환경 변수 설정
ENV_PATH=/mnt/sdb/JHW/envs/work38_cu11
CACHE_DIR=/mnt/sdb/JHW/pip_cache
BUILD_DIR=/mnt/sdb/JHW/build
TMP_DIR=/mnt/sdb/JHW/tmp
PROJECT_DIR=/mnt/sdb/JHW/Projects/emoca
PIP=$ENV_PATH/bin/pip
PYTHON=$ENV_PATH/bin/python

# 디렉토리 생성
mkdir -p "$CACHE_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$TMP_DIR"

export TMPDIR="$TMP_DIR"
export TEMP="$TMP_DIR"
export PYTHON_BUILD_TMPDIR="$TMP_DIR"

# 1. 서브모듈 가져오기
cd "$PROJECT_DIR"
echo "Pulling submodules..."
bash pull_submodules.sh

# 2. Conda 환경 생성 (이미 생성되어 있다면 스킵)
if [ ! -d "$ENV_PATH" ]; then
    echo "Creating conda environment..."
    conda create --prefix "$ENV_PATH" python=3.8 --file conda-environment_py38_cu11_ubuntu.yml
fi

# 3. PyTorch 설치 (conda 환경 파일에서 주석 처리된 경우)
echo "Installing PyTorch..."
mamba install --prefix "$ENV_PATH" pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch

# 4. pip 다운그레이드 (omegaconf 메타데이터 문제 해결)
echo "Downgrading pip..."
$PIP install --cache-dir "$CACHE_DIR" pip==24.0

# 5. Cython 먼저 설치
echo "Installing Cython..."
$PIP install --cache-dir "$CACHE_DIR" --build "$BUILD_DIR" Cython==0.29.14

# 6. requirements38.txt 설치 (flatbuffers 제외)
echo "Installing requirements..."
$PYTHON -m pip install --cache-dir "$CACHE_DIR" --build "$BUILD_DIR" \
    -r requirements38.txt

# 7. 특정 버전으로 재설치 (호환성 문제 해결)
echo "Installing compatible versions..."
$PIP install --cache-dir "$CACHE_DIR" protobuf==3.20.3
$PIP install --cache-dir "$CACHE_DIR" numpy==1.23.5

# 8. PyTorch 1.12.1 확인
echo "Verifying PyTorch installation..."
$PYTHON -c "import torch; print(f'PyTorch: {torch.__version__}, CUDA: {torch.cuda.is_available()}')"

# 9. PyTorch3D 의존성 설치
echo "Installing Pytorch3D dependencies..."
$PIP install --cache-dir "$CACHE_DIR" fvcore iopath

# 10. PyTorch3D 0.7.2 설치 (precompiled wheel)
echo "Installing Pytorch3D 0.7.2..."
$PIP install --no-index --no-cache-dir pytorch3d==0.7.2 \
    -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1121/download.html

# 11. mediapipe 0.10.5 설치 (Python 3.8 호환)
echo "Installing mediapipe..."
$PIP uninstall -y mediapipe || true
$PIP install --cache-dir "$CACHE_DIR" mediapipe==0.10.5

# 12. gdl 설치
echo "Installing GDL package..."
cd "$PROJECT_DIR"
$PIP install --cache-dir "$CACHE_DIR" -e .

echo "=========================================="
echo "설치 완료!"
echo "=========================================="
echo "환경 경로: $ENV_PATH"
echo "활성화: conda activate $ENV_PATH"
echo "또는: source $ENV_PATH/bin/activate"
```

---

## 검증

### 1. 기본 패키지 확인

```bash
# Python 버전
/mnt/sdb/JHW/envs/work38_cu11/bin/python --version
# 예상 출력: Python 3.8.20

# PyTorch 확인
/mnt/sdb/JHW/envs/work38_cu11/bin/python -c "import torch; print(f'PyTorch: {torch.__version__}, CUDA: {torch.cuda.is_available()}')"
# 예상 출력: PyTorch: 1.12.1+cu113, CUDA: True

# PyTorch3D 확인
/mnt/sdb/JHW/envs/work38_cu11/bin/python -c "import pytorch3d; print(f'PyTorch3D: {pytorch3d.__version__}')"
# 예상 출력: PyTorch3D: 0.7.2

# mediapipe 확인
/mnt/sdb/JHW/envs/work38_cu11/bin/python -c "from mediapipe.python.solutions.face_mesh_connections import FACEMESH_CONTOURS; print('mediapipe OK')"
# 예상 출력: mediapipe OK
```

### 2. face_alignment API 수정 확인

```bash
# gdl/utils/FaceDetector.py 파일 확인
grep -n "LandmarksType" /mnt/sdb/JHW/Projects/emoca/gdl/utils/FaceDetector.py
# 예상 출력: 84번째 줄에 LandmarksType.TWO_D가 있어야 함
```

### 3. EMOCA 스크립트 테스트

```bash
cd /mnt/sdb/JHW/Projects/emoca
/mnt/sdb/JHW/envs/work38_cu11/bin/python ./gdl_apps/EMOCA/demos/test_emoca_on_images.py \
    --input_folder /mnt/sdb/JHW/datasets/Aff-wild2/images/9-15-1920x1080_sequence/24/ \
    --output_folder /mnt/sdb/JHW/emoca_results/24 \
    --model_name EMOCA_v2_lr_mse_20
```

---

## 요약: 주요 해결 사항

1. **서브모듈**: 서브모듈 상태 확인 및 문제 해결 (Deep3DFaceRecon_pytorch, face_detection)
2. **Conda 환경 경로**: 특정 경로(`/mnt/sdb/JHW/envs`)에 환경 생성
3. **Conda 환경 파일**: PyTorch 관련 패키지 주석 처리 후 수동 설치
4. **pip 버전**: 24.0으로 다운그레이드 (omegaconf 메타데이터 문제)
5. **pip 경로**: Python 2.7 사용 방지를 위해 직접 경로 사용 (`/path/to/env/bin/pip`)
6. **protobuf**: 3.20.3으로 다운그레이드
7. **numpy**: 1.23.5로 다운그레이드
8. **PyTorch**: 1.12.1+cu113로 고정
9. **PyTorch3D**: 0.7.2 precompiled wheel 사용 (소스 컴파일 대신, fvcore/iopath 의존성 필요)
10. **mediapipe**: 0.10.5로 다운그레이드 (Python 3.8 호환)
11. **flatbuffers**: requirements38.txt에서 제거 (mediapipe와 충돌)
12. **디스크 공간**: 모든 캐시 및 빌드 파일을 `/mnt/sdb/JHW`에 저장, conda cache 정리
13. **face_alignment API**: `LandmarksType._2D` → `LandmarksType.TWO_D`로 수정

---

## 참고 사항

### 파일 수정 내역

#### requirements38.txt 수정 사항

원본에서 다음 수정이 이루어졌습니다:

1. **flatbuffers 제거 (17번째 줄)**
   - **원본**: `flatbuffers~=1.12`
   - **수정**: `# flatbuffers~=1.12  # Removed due to conflict with mediapipe (mediapipe requires flatbuffers>=2.0 or ~=25.9)`
   - **이유**: mediapipe와 의존성 충돌 (문제 5 참조)
   - **결과**: mediapipe 설치 시 자동으로 `flatbuffers 25.12.19`가 설치됨

2. **onnxruntime-gpu 버전 범위 변경 (39번째 줄)**
   - **원본**: `onnxruntime-gpu~=1.9.0`
   - **수정**: `onnxruntime-gpu>=1.9.0  # Updated from ~=1.9.0 as version not available`
   - **이유**: 정확한 버전 1.9.0이 PyPI에서 사용 불가능
   - **결과**: 호환 가능한 최신 버전 설치

3. **mediapipe 버전 범위 변경 (72-73번째 줄)**
   - **원본**: `mediapipe==0.8.10`
   - **수정**: 
     ```
     # mediapipe==0.8.10  # Version not available, will install compatible version separately
     mediapipe>=0.8.10
     ```
   - **이유**: 버전 0.8.10이 PyPI에서 더 이상 제공되지 않음
   - **결과**: Python 3.8과 호환되는 `mediapipe 0.10.5`로 수동 설치 (문제 9 참조)

#### conda-environment_py38_cu11_ubuntu.yml 수정 사항

1. **PyTorch 관련 라인 주석 처리 (24-29번째 줄)**
   - **원본**: 
     ```yaml
     - pytorch=1.12.1=py3.8_cuda11.3_cudnn8.3.2_0
     - torchvision=0.11.3
     - torchaudio=0.10.2
     ```
   - **수정**: 
     ```yaml
     # PyTorch will be installed manually after environment creation
     # - pytorch=1.9.1=py3.8_cuda11.1_cudnn8.0.5_0 #notusing
     # - pytorch=1.10.2=py3.8_cuda11.3_cudnn8.2.0_0 #notusing
     # - pytorch=1.12.1=py3.8_cuda11.3_cudnn8.3.2_0
     # - torchvision=0.11.3
     # - torchaudio=0.10.2
     ```
   - **이유**: conda를 통한 자동 설치가 실패하거나 버전 불일치 발생 가능
   - **결과**: 환경 생성 후 수동으로 `mamba install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch` 실행

### 설치된 주요 패키지 버전 (최종 상태)

#### requirements38.txt 기준 비교

| 패키지 | requirements38.txt 요구사항 | 실제 설치 버전 | 비고 |
|--------|---------------------------|---------------|------|
| Python | 3.8 (conda) | 3.8.20 | ✅ 일치 |
| PyTorch | 1.12.1 (수동 설치) | 1.12.1+cu113 | ✅ 일치 |
| PyTorch3D | git@v0.6.2 (주석 처리됨) | 0.7.2 | ⚠️ precompiled wheel 사용 (문제 8) |
| face-alignment | ~=1.3.3 | 1.3.6 | ✅ 호환 |
| flatbuffers | ~=1.12 (제거됨) | 25.12.19 | ⚠️ mediapipe가 자동 설치 |
| mediapipe | >=0.8.10 | 0.10.5 | ⚠️ 수동 설치 (문제 9) |
| numpy | >=1.23.1 | 1.23.5 | ⚠️ 수동 다운그레이드 (문제 7) |
| protobuf | ~=3.14.0 | 3.20.3 | ⚠️ 수동 다운그레이드 (문제 6) |
| omegaconf | ~=2.0.6 | 2.0.6 | ✅ 일치 |
| onnxruntime-gpu | >=1.9.0 | (설치됨) | ✅ 호환 버전 설치 |

#### 주요 패키지 상세

- **Python**: 3.8.20
- **PyTorch**: 1.12.1+cu113
- **PyTorch3D**: 0.7.2 (precompiled wheel, 원래 요구사항 0.6.2 대신)
- **mediapipe**: 0.10.5 (원래 요구사항 0.8.10 대신, Python 3.8 호환)
- **protobuf**: 3.20.3 (원래 요구사항 ~=3.14.0 대신, 호환성 문제 해결)
- **numpy**: 1.23.5 (원래 요구사항 >=1.23.1, 호환성 문제 해결)
- **pip**: 24.0 (원래 최신 버전 대신, omegaconf 메타데이터 문제 해결)
- **omegaconf**: 2.0.6
- **face-alignment**: 1.3.6
- **flatbuffers**: 25.12.19 (mediapipe 의존성으로 자동 설치)

### 환경 경로

- Conda 환경: `/mnt/sdb/JHW/envs/work38_cu11`
- 프로젝트: `/mnt/sdb/JHW/Projects/emoca`
- 캐시 디렉토리: `/mnt/sdb/JHW/pip_cache`
- 빌드 디렉토리: `/mnt/sdb/JHW/build`
- 임시 디렉토리: `/mnt/sdb/JHW/tmp`

### 설치 완료 확인

다음 명령어로 현재 설치 상태를 확인할 수 있습니다:

```bash
# 주요 패키지 버전 확인
/mnt/sdb/JHW/envs/work38_cu11/bin/pip list | grep -E "(protobuf|numpy|mediapipe|omegaconf|pytorch3d|face-alignment|flatbuffers|torch)"

# 예상 출력:
# face-alignment            1.3.6
# flatbuffers               25.12.19
# mediapipe                 0.10.5
# numpy                     1.23.5
# omegaconf                 2.0.6
# protobuf                  3.20.3
# pytorch3d                 0.7.2
# torch                     1.12.1+cu113
```

**설치 상태 요약:**
- ✅ **requirements38.txt의 모든 패키지 설치 완료** (수정된 버전 기준)
- ✅ **conda-environment_py38_cu11_ubuntu.yml의 모든 패키지 설치 완료**
- ⚠️ **일부 패키지는 호환성을 위해 다른 버전으로 설치됨** (위 표 참조)
- ✅ **모든 의존성 충돌 해결됨**
- ✅ **EMOCA 스크립트 실행 가능** (face_alignment API 수정 후)

---

## 추가 문제 발생 시

1. **모듈 import 오류**: 패키지 버전 확인 및 재설치
2. **CUDA 관련 오류**: PyTorch와 CUDA 버전 호환성 확인
3. **의존성 충돌**: 개별 패키지 설치로 문제 격리
4. **디스크 공간 부족**: 캐시 및 빌드 디렉토리 정리

---

**작성일**: 2024년
**환경**: Linux, Python 3.8, CUDA 11.3, PyTorch 1.12.1

