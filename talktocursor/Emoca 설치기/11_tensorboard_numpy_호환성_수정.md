# 11단계: tensorboard numpy 호환성 수정

## 작업 완료 시간
2025년 2월 26일

## 문제 상황
EMOCA 스크립트 실행 시 다음 오류 발생:
```
AttributeError: module 'numpy' has no attribute 'object'.
```

## 원인
- numpy가 1.24.4로 설치되어 있었음
- numpy 1.24.3부터 `np.object`가 제거됨
- `alreadyinstalled` 가이드에 따르면 numpy 1.23.5를 사용해야 함

## 해결 방법

### numpy 1.23.5로 다운그레이드
`alreadyinstalled` 가이드의 "문제 7"에 따라 numpy를 1.23.5로 다운그레이드:

```bash
conda activate work38_cu11

# numpy 1.23.5로 다운그레이드
pip install --cache-dir /media/cine/First/HWPJ2/Temp/pip_cache --force-reinstall numpy==1.23.5
```

**참고:** 
- numpy 1.23.5는 `np.object`를 지원함
- tensorboard와 호환됨
- 복잡한 파일 패치가 필요 없음

### 패치 확인
```bash
grep -n "object,\|bool,\|int,\|float," "$TB_FILE" | head -5
```

**예상 결과:**
```
569:        (object, string),
570:        (bool, bool),
```

### 검증
```bash
conda activate work38_cu11

# numpy 버전 확인
python -c "import numpy; print(f'numpy: {numpy.__version__}')"
# 예상 결과: numpy: 1.23.5

# tensorboard import 테스트
python -c "from torch.utils.tensorboard import SummaryWriter; print('✅ tensorboard import 성공!')"
```

## 해결 완료
- numpy 1.23.5로 다운그레이드하여 `np.object` 문제 해결
- 복잡한 파일 패치 없이 간단하게 해결됨
- `alreadyinstalled` 가이드의 "문제 7" 해결 방법과 동일

## 참고
- numpy 1.23.5는 `np.object`를 지원함
- tensorboard와 호환됨
- 다른 컴퓨터에서도 export 없이 정상 작동함

## 다음 단계
이제 EMOCA 스크립트를 정상적으로 실행할 수 있습니다.

