# radio-recorder

rtmp 프로토콜로 전송되는 라디오를 mp3 형식으로 저장합니다.

## Docker Hub
https://hub.docker.com/repository/docker/nuyar/radio-recorder


## Deploy

`/DATA_DIRECTORY` `/SAVE_DIRECTORY`를 각자 필요에 맞게 설정하시면 됩니다.


### command
	sudo docker pull nuyar/radio-recorder
	sudo docker run -d name radio-recorder-1 -e TZ=Asia/Seoul -v /DATA_DIRECTORY:/data -v /SAVE_DIRECTORY:/recorded nuyar/radio-recorder


### schedule.txt

도커를 실행하면 `/DATA_DIRECTORY`에 `schedule.txt` 파일이 생기고 종료됩니다.

해당 파일에 한 줄에 하나의 방송을 적은 후 다시 시작하면 녹화가 시작됩니다.

아래의 예시는 매일 18시 정각부터 1시간 동안 녹화하고 `/SAVE_DIRECTORY/ebs/sixpmradio_DATE_TIME.mp3` 파일에 저장합니다.

	#{시작시간(시)} {시작시간(분)} {RTMP주소} {녹화시간(분)} {방송제목(파일이름)} {저장폴더}
	18 00 rtmp://ebs~~/ 60 sixpmradio ebs
