# 작업 디렉토리를 /home/ubuntu으로 변경
cd /home/ubuntu

# 환경변수 DOCKER_APP_NAME 설정
DOCKER_APP_NAME=honge7694

# 실행 중인 blue가 있는지 확인
# 프로젝트의 실행 중인 컨테이너를 확인하고, 해당 컨테이너가 실행 중인지를 EXIST_BLUE 변수에 저장
EXIST_BLUE=$(sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml ps | grep Up)

# 배포 시작한 날짜와 시간을 기록
echo "배포 시작 일자 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log

# green이 실행 중이면 blue up
# EXIST_BLUE 변수가 비어있는지 확인
if [ -z "$EXIST_BLUE" ]; then

  # 로그 파일(/home/ubuntu/deploy.log)에 "blue up - blue 배포 : port:8081"이라는 내용을 추가
  echo "blue 배포 시작 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log

	# docker-compose.blue.yml 파일을 사용하여 seniors-blue 프로젝트의 컨테이너를 빌드하고 실행
	sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up -d --build

  # 30초 동안 대기
  sleep 30

  # blue가 문제없이 배포되었는지 현재 실행 여부를 확인
  BLUE_HEALTH=$(sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml ps | grep Up)

  # blue가 현재 실행 중이지 않다면 -> 런타임 에러 또는 다른 이유로 배포가 되지 못한 상태
  if [ -z "$BLUE_HEALTH" ]; then
    # slack으로 알람을 보낼 수 있는 스크립트를 실행
    sudo ./slack_blue.sh
  # blue가 현재 실행되고 있는 경우에만 green을 종료
  else

    # /home/ubuntu/deploy.log: 로그 파일에 "green 중단 시작"이라는 내용을 추가
    echo "green 중단 시작 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log

    # docker-compose.green.yml 파일을 사용하여 seniors-green 프로젝트의 컨테이너를 중지
    sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml down

    # 사용하지 않는 이미지 삭제
    sudo docker image prune -af

    echo "green 중단 완료 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log
  fi

# blue가 실행중이면 green up
else
	echo "green 배포 시작 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log
	sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml up -d --build

  sleep 30

  GREEN_HEALTH=$(sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml ps | grep Up)

  if [ -z "$GREEN_HEALTH" ]; then

      sudo ./slack_green.sh
  else

      # /home/ubuntu/deploy.log: 로그 파일에 "blue 중단 시작"이라는 내용을 추가
      echo "blue 중단 시작 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log

      # docker-compose.blue.yml 파일을 사용하여 seniors-green 프로젝트의 컨테이너를 중지
      sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml down

      # 사용하지 않는 이미지 삭제
      sudo docker image prune -af

      echo "blue 중단 완료 : $(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)" >> /home/ubuntu/deploy.log
  fi
fi
