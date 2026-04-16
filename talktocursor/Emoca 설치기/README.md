# EMOCA 설치 가이드

이 폴더는 EMOCA 환경 구성을 단계별로 진행하면서 기록한 가이드입니다.

## 파일 구조

### 주요 가이드
- `00_설치_진행상황.md` - 전체 설치 진행 상황 및 단계별 요약
- `README.md` - 이 파일 (전체 가이드 개요)

### 단계별 상세 가이드
- `01_서브모듈_초기화.md` - 서브모듈 초기화 상세 가이드
- `02_Conda_환경_생성.md` - Conda 환경 생성 및 디스크 공간 관리
- `03_PyTorch_설치.md` - PyTorch 설치 및 CUDA 확인
- `04_pip_및_기본패키지_설치.md` - pip 다운그레이드, Cython, requirements38.txt 설치
- `06_PyTorch3D_설치.md` - PyTorch3D 0.7.2 precompiled wheel 설치
- `07_mediapipe_설치.md` - mediapipe 설치 및 OpenCV 충돌 해결
- `07-1_mediapipe_문제해결.md` - kiwisolver GLIBCXX 문제 해결
- `08_GDL_패키지_설치.md` - GDL 패키지 설치 (editable mode)
- `09_face_alignment_API_수정.md` - face_alignment API 수정
- `10_설치_검증.md` - 설치 검증 및 패키지 버전 확인
- `11_tensorboard_numpy_호환성_수정.md` - numpy 1.23.5 다운그레이드
- `12_psutil_문제_해결.md` - psutil 소스 재컴파일

### 환경 파일
- `conda-environment_py38_cu11_ubuntu.yml` - Conda 환경 정의 파일 (복사본)

## 설치 환경

- **환경 이름**: `work38_cu11`
- **Python 버전**: 3.8.20
- **프로젝트 경로**: `/media/cine/First/HWPJ2/NewProject/External Projects/emoca`
- **Conda 환경 경로**: `/home/cine/anaconda3/envs/work38_cu11`

## 설치 순서 요약

1. **서브모듈 초기화** (`01_서브모듈_초기화.md`)
2. **Conda 환경 생성** (`02_Conda_환경_생성.md`)
3. **PyTorch 설치** (`03_PyTorch_설치.md`)
4. **pip 및 기본 패키지 설치** (`04_pip_및_기본패키지_설치.md`)
5. **PyTorch3D 설치** (`06_PyTorch3D_설치.md`)
6. **mediapipe 설치** (`07_mediapipe_설치.md`, `07-1_mediapipe_문제해결.md`)
7. **GDL 패키지 설치** (`08_GDL_패키지_설치.md`)
8. **face_alignment API 수정** (`09_face_alignment_API_수정.md`)
9. **설치 검증** (`10_설치_검증.md`)
10. **호환성 문제 해결** (`11_tensorboard_numpy_호환성_수정.md`, `12_psutil_문제_해결.md`)

## 주요 해결한 문제

1. **디스크 공간 부족** - conda 캐시를 `/media/cine/First/HWPJ2/Temp/conda_pkgs`로 이동
2. **numpy.object 오류** - numpy 1.23.5로 다운그레이드
3. **psutil getpagesize 오류** - 소스에서 재컴파일
4. **mediapipe GLIBCXX 문제** - conda로 matplotlib, kiwisolver 재설치 및 LD_LIBRARY_PATH 설정
5. **OpenCV 충돌** - opencv-contrib-python 제거

## 참고 자료

- `alreadyinstalled/INSTALLATION_TROUBLESHOOTING.md` - 상세 문제 해결 가이드 (이전 설치 경험)
- `alreadyinstalled/install_emoca_complete.sh` - 통합 설치 스크립트 (참고용)

## 설치 완료 후 사용 방법

```bash
cd "/media/cine/First/HWPJ2/NewProject/External Projects/emoca"
source /home/cine/anaconda3/etc/profile.d/conda.sh
conda activate work38_cu11
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

python ./gdl_apps/EMOCA/demos/test_emoca_on_images.py \
    --input_folder /media/cine/First/Aff-wild2/images/9-15-1920x1080_sequence/24/ \
    --output_folder /media/cine/First/HWPJ2/ProjectResult/EMOCA_Res \
    --model_name EMOCA_v2_lr_mse_20
```

## 환경 변수 영구 설정 (선택사항)

환경 활성화 시 자동으로 LD_LIBRARY_PATH가 설정되도록 하려면:

```bash
conda activate work38_cu11
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
```

## 설치된 주요 패키지 버전

- PyTorch: 1.12.1+cu113
- PyTorch3D: 0.7.2
- mediapipe: 0.10.5
- numpy: 1.23.5
- protobuf: 3.20.3
- omegaconf: 2.0.6
- face-alignment: 1.3.6
- pytorch-lightning: 1.4.9
- GDL: 0.0.3 (editable mode)
