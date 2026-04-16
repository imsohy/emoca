# 6단계: PyTorch3D 설치

## 작업 완료 시간
2025년 2월 26일

## 설치 내용

### 설치된 패키지
- **PyTorch3D**: 0.7.2 (precompiled wheel)
- **fvcore**: 0.1.5.post20221221
- **iopath**: 0.1.10

### 설치 방법
Facebook 공식 precompiled wheel 사용 (소스 컴파일 대신, 빠르고 안정적)

### 설치 명령어

#### 1. 필수 의존성 설치
```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache fvcore iopath
```

#### 2. PyTorch3D 0.7.2 설치
```bash
pip uninstall -y pytorch3d 2>/dev/null || true

pip install --no-index --no-cache-dir pytorch3d==0.7.2 \
    -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py38_cu113_pyt1121/download.html
```

### 설치 확인
```bash
conda activate work38_cu11
python -c "import pytorch3d; print(f'PyTorch3D: {pytorch3d.__version__}')"
```

**결과:**
```
PyTorch3D: 0.7.2
```

## 중요 사항

### 버전 호환성
- **Python**: 3.8 (py38)
- **CUDA**: 11.3 (cu113)
- **PyTorch**: 1.12.1 (pyt1121)

이 세 가지가 모두 일치해야 precompiled wheel을 사용할 수 있습니다.

### PyTorch3D 0.7.2 vs 0.6.2
- README는 PyTorch3D 0.6.2를 권장하지만, 공식 precompiled wheel이 없음
- PyTorch3D 0.7.2는 0.6.2와 대부분 호환됨
- 주요 차이점:
  - `Textures`가 `pytorch3d.structures`에서 `pytorch3d.renderer`로 이동
  - `TexturedSoftPhongShader` 제거됨 (EMOCA에서 사용하지 않으면 문제 없음)
  - 대부분의 핵심 API는 호환됨 (Meshes, MeshRenderer, HardPhongShader 등)

### Precompiled Wheel 사용 이유
- 소스 컴파일은 시간이 오래 걸리고 문제가 발생할 수 있음
- Precompiled wheel은 빠르고 안정적
- Facebook 공식 제공

## 다음 단계
7단계: mediapipe 설치

