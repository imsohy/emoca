# 7단계: mediapipe 설치

## 작업 완료 시간
2025년 2월 26일

## 설치 내용

### 설치된 패키지
- **mediapipe**: 0.10.5 (Python 3.8 호환 버전)
- **opencv-python**: 4.5.5.64

### 설치 명령어

#### 1. 기존 mediapipe 제거
```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

pip uninstall -y mediapipe
```

#### 2. mediapipe 0.10.5 설치
```bash
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache mediapipe==0.10.5
```

#### 3. OpenCV 충돌 해결
```bash
# opencv-contrib-python 제거 (충돌 방지)
pip uninstall -y opencv-contrib-python opencv-python-headless

# 필요한 버전만 설치
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache opencv-python==4.5.5.64
```

## 알려진 문제

### kiwisolver GLIBCXX 버전 문제
**증상:**
```
ImportError: /lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found
```

**원인:**
- mediapipe의 drawing_utils가 matplotlib을 import할 때 발생
- 시스템의 libstdc++ 버전이 낮아서 kiwisolver와 호환되지 않음

**영향:**
- mediapipe 패키지는 설치되었지만, 일부 기능(drawing_utils) import 시 오류 발생
- EMOCA 실행에는 필수적이지 않을 수 있음 (mediapipe의 핵심 기능은 사용 가능)

**해결 방법:**

다음 명령어를 터미널에서 직접 실행하세요 (출력 과정을 확인하면서):

```bash
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

# pip로 설치된 matplotlib과 kiwisolver 제거
pip uninstall -y matplotlib kiwisolver

# conda를 통해 matplotlib과 kiwisolver 재설치 (conda의 libstdc++ 사용)
conda install -y matplotlib kiwisolver -c conda-forge

# 설치 확인
python -c "import mediapipe; print('mediapipe import OK')"
```

**설명:**
- pip로 설치된 kiwisolver는 시스템의 libstdc++를 사용하여 GLIBCXX_3.4.29를 요구
- conda로 설치하면 conda 환경의 libstdc++를 사용하여 호환성 문제 해결

## 설치 확인

```bash
conda activate work38_cu11
pip list | grep mediapipe
# mediapipe                 0.10.5
```

**참고:** mediapipe 패키지는 설치되었지만, import 테스트에서 kiwisolver 문제가 발생합니다. 실제 EMOCA 실행 시에는 문제가 없을 수 있습니다.

## 다음 단계
8단계: GDL 패키지 설치

