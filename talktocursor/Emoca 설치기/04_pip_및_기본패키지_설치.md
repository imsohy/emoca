# 4단계: pip 다운그레이드 및 기본 패키지 설치

## 작업 완료 시간
2025년 2월 26일

## 작업 내용

### 1. pip 다운그레이드 (work38_cu11 환경 내에서만)
```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache pip==24.0
```

**결과:**
- pip 24.2 → 24.0 다운그레이드 완료
- **주의**: 이 작업은 work38_cu11 환경 내에서만 수행됨 (전체 시스템에 영향 없음)

### 2. Cython 설치
```bash
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache Cython==0.29.14
```

**결과:**
- Cython 0.29.14 설치 완료

### 3. requirements38.txt 설치
```bash
cd "/media/cine/First/HWPJ2/NewProject/External Projects/emoca"
python -m pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache -r alreadyinstalled/requirements38.txt
```

**설치된 주요 패키지:**
- omegaconf 2.0.6
- face-alignment 1.3.6
- pytorch-lightning 1.4.9
- mediapipe 0.10.32 (나중에 0.10.5로 다운그레이드 예정)
- 기타 의존성 패키지들

**주의 사항:**
- flatbuffers는 이미 requirements38.txt에서 주석 처리되어 있어 자동으로 제외됨
- mediapipe 설치 시 flatbuffers 25.12.19가 자동으로 설치됨
- 일부 의존성 충돌 경고 발생 (jupyter 관련, seaborn 등) - 나중에 해결 가능

### 4. 호환성 패키지 수정

#### protobuf 재설치
```bash
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache --force-reinstall protobuf==3.20.3
```

**이유:** requirements38.txt에서 protobuf~=3.14.0이 설치되었지만, 호환성 문제로 3.20.3이 필요

#### numpy 재설치
```bash
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache --force-reinstall numpy==1.23.5
```

**이유:** numpy 1.24+에서 `np.object`가 제거되어 일부 패키지와 호환성 문제 발생

## 환경 변수 설정

모든 임시 파일과 캐시를 `/media/cine/First/HWPJ2/Temp`에 저장:
```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache
```

## 다음 단계
6단계: PyTorch3D 설치

