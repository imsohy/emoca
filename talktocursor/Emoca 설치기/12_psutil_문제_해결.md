# 12단계: psutil 문제 해결

## 작업 완료 시간
2025년 2월 26일

## 문제 상황
EMOCA import 시 다음 오류 발생:
```
AttributeError: module 'psutil._psutil_posix' has no attribute 'getpagesize'
```

## 원인
- psutil이 다른 환경에서 컴파일되어 현재 환경과 호환되지 않음
- 바이너리 wheel이 현재 시스템과 맞지 않음

## 해결 방법

### 소스에서 재컴파일 (권장)
```bash
conda activate work38_cu11

# 기존 psutil 제거
pip uninstall -y psutil

# 소스에서 재컴파일
pip install --no-binary psutil psutil==5.7.3
```

**결과:**
```
✅ psutil import 성공! 버전: 5.7.3
```

## 대안 방법

### 방법 1: conda로 설치
```bash
conda activate work38_cu11
pip uninstall -y psutil
conda install -y psutil=5.7.3 -c conda-forge
```


## 참고
- `--no-binary` 옵션은 소스에서 컴파일하도록 강제함
- 현재 시스템에 맞게 컴파일되어 호환성 문제 해결
- psutil 5.7.3은 requirements38.txt에 명시된 버전

