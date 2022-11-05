# PhotosUI + AVKit + CoreData Sample Project
### 팀 8BIT의 클라이밍 영상 분류 앱 [오르락(ORRROCK)](https://github.com/DeveloperAcademy-POSTECH/MacC-TEAM-8bit)의 기능의 기술 검증을 위한 예시 프로젝트입니다.**

### 검증할 기술 & 결과 & 방법
|검증 기술|결과|방법|
|:---|:---:|:---|
|**사진 앱으로부터 영상의 Reference를 들고와 이를 저장할 수 있는가?**|**YES**|**PHAsset의 LocalIdentifier를 사용**|
|**사진 앱으로부터 들고온 영상의 Reference를 기반으로 영상을 재생할 수 있는가?**|**YES**|**PHAsset으로부터 영상 데이터를 뽑아내어 사용**|

### PHAssetTypeViewController.swift Component 설명

|샘플 프로젝트 이미지|
|:---:|
|<img width="360" alt="" src="https://user-images.githubusercontent.com/96641477/200135006-5d2bbfdc-3ec7-4b1b-a2cf-7fd83be5e19d.png">|

|버튼 이름|버튼 역할|
|:---:|:---|
|**Remove All Video**|Core Data에 저장된 모든 VideoInfo Record 전체를 삭제|
|**POP PHPICKER**|사진 앱으로부터 선택할 영상을 추출할 때 띄워줄 PHPicker를 POP|
|**Play Video Button**|Core Data에 저장된 VideoInfo Record의 첫번째 Index 영상을 재생|
|**Video Save**|PHPicker를 통해 선택된 동영상들의 Local Identifier를 Core Data VideoInfo Record에 저장|


**SEQUENCE**
- 기본 플로우: 사진 앱에서 영상 들고오기 -> 데이터 저장 -> 샘플 앱에서 영상 재생**
1. 사진 앱으로부터 영상에 대한 정보를 PHAsset으로 들고옵니다.
2. PHAsset으로 들고온 영상의 메타데이터에서 LocalIdentifier를 들고옵니다.
3. LocalIdentifier를 CoreData의 VideoInfo Entity의 `videoName`으로 저장합니다.
4. 저장된 LocalIdentifier를 기반으로 사진 앱의 영상 Reference를 들고와 앱 내에서 영상을 재생합니다.

**⚠️주의 사항⚠️**
- **`POP PHPICKER`버튼을 통해 띄워지니 PHPicker에서 영상을 선택한 후 `Video Save`버튼을 누르지 않을 경우 Core Data에 Record가 쌓이지 않습니다.**
- **Core Data에 Record가 하나도 존재하지 않는 시점에서 `Play Video Button`을 누르는 경우 앱의 Crash가 발생합니다.**
