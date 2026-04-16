# 2단계: Conda 환경 생성

## 작업 시작 시간
2025년 2월 26일

## 문제 발생 및 해결

### 문제: /home 디스크 공간 부족
- **상태**: /home 디스크가 100% 사용 중 (524MB만 남음)
- **원인**: conda 패키지 캐시가 /home에 쌓임
- **해결**: 
  1. conda 캐시 정리 (`conda clean --all --yes`) - 약 13GB 정리
  2. conda 설정 변경하여 패키지 캐시를 `/media/cine/First/HWPJ2/Temp/conda_pkgs`로 이동

### Conda 설정 변경

**~/.condarc 파일 수정:**
```yaml
solver: libmamba
channel_priority: strict
pkgs_dirs:
  - /media/cine/First/HWPJ2/Temp/conda_pkgs
```

**환경 변수 설정:**
```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
```

## Conda 환경 생성

### 환경 정보
- **환경 이름**: `work38_cu11`
- **Python 버전**: 3.8
- **환경 파일**: `alreadyinstalled/conda-environment_py38_cu11_ubuntu.yml`
- **주의**: PyTorch는 주석 처리되어 있으므로 환경 생성 후 수동 설치 필요

### 생성 명령어
```bash
cd "/media/cine/First/HWPJ2/NewProject/External Projects/emoca"

# 환경 변수 설정 (임시 파일도 Temp 디렉토리 사용)
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp

# Conda 환경 생성
conda env create -n work38_cu11 --file alreadyinstalled/conda-environment_py38_cu11_ubuntu.yml
```

### 예상 설치 시간
- 약 10-20분 소요 (네트워크 속도에 따라 다름)

### 설치되는 주요 패키지
- Python 3.8
- ffmpeg, ffmpeg-python
- matplotlib-base
- moviepy
- pandas, numpy
- scikit-learn, scikit-image, scikit-video
- transformers
- kornia, pyrender
- 기타 의존성 패키지들

**주의**: PyTorch는 이 단계에서 설치되지 않음 (다음 단계에서 수동 설치)

## 검증

환경 생성 후 확인:
```bash
conda env list | grep work38_cu11
# work38_cu11                /home/cine/anaconda3/envs/work38_cu11

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11
python --version  # Python 3.8.x 확인
```

**결과:**
- ✅ 환경 생성 완료
- ✅ Python 3.8 설치 확인
- ✅ 기본 패키지 설치 완료

## 추가 해결한 문제

### channel_priority 충돌
- **문제**: `channel_priority: strict` 설정으로 인한 패키지 충돌
- **에러**: `LibMambaUnsatisfiableError: ffmpeg, libiconv 패키지 충돌`
- **해결**: ~/.condarc에서 `channel_priority: flexible`로 변경

## 다음 단계
3단계: PyTorch 설치

