# 3단계: PyTorch 설치

## 작업 완료 시간
2025년 2월 26일

## 설치 내용

### 설치된 패키지
- **PyTorch**: 1.12.1 (CUDA 11.3 지원)
- **torchvision**: 0.13.1
- **torchaudio**: 0.12.1
- **cudatoolkit**: 11.3.1

### 설치 명령어
```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch -y
```

### 설치 확인
```bash
conda activate work38_cu11
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}')"
```

**결과:**
```
PyTorch: 1.12.1
CUDA available: True
CUDA version: 11.3
```

### 참고 사항
- PyTorch는 conda 환경 생성 시 주석 처리되어 있었으므로 별도로 설치
- 총 약 2.42GB의 패키지 다운로드 및 설치
- CUDA 11.3이 정상적으로 인식됨

## 다음 단계
4단계: pip 다운그레이드 및 기본 패키지 설치

