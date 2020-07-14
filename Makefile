INSTALL_DIR=/opt/illpro/rpi-cam/
SERVICE_DIR=/etc/systemd/system/

SCRIPT=rpi-cam.sh
SERVICE=rpi-cam.service

OWNER=root
GROUP=root

.PHONY: rpi-cam install remove

rpi-cam:
	@echo 'run "make install" to copy files into place.'

install:
	mkdir -p ${INSTALL_DIR}
	cp ${SCRIPT} ${INSTALL_DIR}${SCRIPT}
	chown ${OWNER}:${GROUP} ${INSTALL_DIR}${SCRIPT}
	chmod 755 ${INSTALL_DIR}${SCRIPT}

	cp ${SERVICE} ${SERVICE_DIR}${SERVICE}
	chown ${OWNER}:${GROUP} ${SERVICE_DIR}${SERVICE}
	chmod 644 ${SERVICE_DIR}${SERVICE}
	systemctl daemon-reload
	systemctl enable rpi-cam

remove:
	systemctl stop rpi-cam
	systemctl disable rpi-cam
	rm -r ${SERVICE_DIR}${SERVICE}
	systemctl daemon-reload
	rm -r ${INSTALL_DIR}
