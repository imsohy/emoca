# 7-1단계: mediapipe kiwisolver 문제 해결

## 문제 상황
mediapipe 0.10.5는 설치되었지만, import 시 다음 오류 발생:
```
ImportError: /lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found
```

## 원인
- pip로 설치된 kiwisolver와 matplotlib이 시스템의 libstdc++를 사용
- 시스템의 libstdc++는 GLIBCXX_3.4.28까지만 지원
- conda로 설치한 패키지도 시스템의 libstdc++를 우선 사용하여 문제 발생

## 해결 방법

다음 명령어를 터미널에서 직접 실행하세요:

```bash
# 환경 변수 설정
export CONDA_PKGS_DIRS=/media/cine/First/HWPJ2/Temp/conda_pkgs
export TMPDIR=/media/cine/First/HWPJ2/Temp
export TEMP=/media/cine/First/HWPJ2/Temp
export PIP_CACHE_DIR=/media/cine/First/HWPJ2/Temp/pip_cache

# conda 환경 활성화
source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11

# pip로 설치된 matplotlib과 kiwisolver 제거
pip uninstall -y matplotlib kiwisolver

# conda를 통해 matplotlib과 kiwisolver 재설치
conda install -y matplotlib kiwisolver -c conda-forge

# LD_LIBRARY_PATH 설정 (conda 환경의 libstdc++ 우선 사용)
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# 설치 확인
python -c "import mediapipe; print('✅ mediapipe import 성공!'); print(f'mediapipe 버전: {mediapipe.__version__}')"
```

## 예상 결과
```
✅ mediapipe import 성공!
mediapipe 버전: 0.10.5
```

## 해결 방법 설명
1. **conda로 matplotlib, kiwisolver 재설치**: conda 환경의 libstdc++를 사용하는 버전 설치
2. **LD_LIBRARY_PATH 설정**: conda 환경의 libstdc++를 우선적으로 사용하도록 설정
   - conda 환경에는 libstdcxx 15.2.0이 설치되어 있어 GLIBCXX_3.4.29를 지원
   - 시스템의 libstdc++는 GLIBCXX_3.4.28까지만 지원

## 영구 설정 (선택사항)
환경 활성화 시 자동으로 LD_LIBRARY_PATH가 설정되도록 하려면:
```bash
# conda 환경의 activate 스크립트에 추가
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
```

이렇게 하면 `conda activate work38_cu11` 할 때마다 자동으로 LD_LIBRARY_PATH가 설정됩니다.

## 검증 결과
✅ mediapipe import 성공
✅ face_mesh_connections import 성공
✅ matplotlib import 성공
✅ 모든 테스트 통과
