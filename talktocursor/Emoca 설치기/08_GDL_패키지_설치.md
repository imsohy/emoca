# 8단계: GDL 패키지 설치

## 작업 완료 시간
2025년 2월 26일

## 설치 내용

### 설치된 패키지
- **GDL**: 0.0.3 (editable mode)

### 설치 명령어
```bash
cd "/media/cine/First/HWPJ2/NewProject/External Projects/emoca"

export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache
export LD_LIBRARY_PATH=/home/cine/anaconda3/envs/work38_cu11/lib:$LD_LIBRARY_PATH

source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

# GDL 패키지 설치 (editable mode)
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache -e .
```

### 설치 확인
```bash
conda activate work38_cu11
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

python -c "import gdl; print('✅ GDL import 성공!'); print(f'GDL 경로: {gdl.__file__}')"
python -c "import gdl_apps; print('✅ gdl_apps import 성공!')"
```

**결과:**
```
✅ GDL import 성공!
GDL 경로: /media/cine/First/HWPJ2/NewProject/External Projects/emoca/gdl/__init__.py
✅ gdl_apps import 성공!
```

## 알려진 경고

### numpy.object 경고
**증상:**
```
AttributeError: module 'numpy' has no attribute 'object'.
```

**원인:**
- tensorboard가 구버전 numpy API (`np.object`)를 사용
- numpy 1.23.5에서 `np.object`가 제거됨

**영향:**
- 경고 메시지가 출력되지만, 실제 import는 성공
- EMOCA 실행에는 문제가 없을 수 있음

**참고:**
- 이미 numpy 1.23.5로 설치되어 있음 (호환성을 위해)
- tensorboard는 다른 패키지의 의존성으로 설치됨

## Editable Mode
- `-e` 옵션으로 설치하여 코드 변경 시 즉시 반영됨
- 프로젝트 디렉토리의 코드를 직접 사용

## 다음 단계
9단계: face_alignment API 수정

