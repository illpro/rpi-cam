# RaspberryPi WebCam
Run an HttpLiveStreaming server on your [Raspberry Pi][1] with
[Camera Module][2]. Some notable features include html5 video support and a
RAM disk which will help maximize the life of your Pi's SD card. The one major
dependency for this project is [`raspivid`][3], which is included in a standard
[Raspbian][4] installation.

#### Install

Open a terminal and `cd` into the same directory that contains this file. Then
run `make install` as root to copy the files into place and enable the systemd
service.

    :$ cd ~/some/path/rpi-cam
    :$ sudo make install

#### Remove

To remove this project follow the same instructions for installing, just change
the make target to `remove`. This will disable the systemd service and remove
the copied files.

    :$ cd ~/some/path/rpi-cam
    :$ sudo make remove

#### Hosting

The RAM disk will be created at `/mnt/rpi-cam-ramdisk` or where ever you
configure it to go, all the necessary video stream files will be located inside
there. You will want to host this directory with your web server (nginx, 
apache). Here is a simple nginx example:

    server {
        listen 80;
        server_name www.mysite.com
        location /cam {
                alias /mnt/rpi-cam-ramdisk;
        }
    }

Once you have setup your web server, you can add the stream to a web page, here
is an example html snippet:

    <video controls="controls" width="720" height="480" autoplay="autoplay" controls playsinline>
        <source src="cam/stream.m3u8" type="application/x-mpegURL" />
    </video>

#### Configuration

You can configure the video stream service with these environment variables,
the easiest thing to do is set them in rpi-cam.service.


**`RPICAM_RAMDISK_PATH`**  
Where the RAM Disk will be placed on your server. Defaults to 
`/mnt/rpi-cam-ramdisk`

**`RPICAM_RAMDISK_SIZE`**  
The size of the RAM Disk, you shouldn't really be changing this unless you
need to support large HD streams. Defaults to `32M`

**`RPICAM_VIDEO_WIDTH`**  
The pixel width of the video stream. Defaults to `720`.

**`RPICAM_VIDEO_HEIGHT`**  
The pixel height of the video stream. Defaults to `480`.

**`RPICAM_VIDEO_FPS`**  
The frames per second for the video stream. Defaults to `30`.

**`RPICAM_VIDEO_BITRATE`**  
The bit rate for the video stream. Defaults to `1150000` bits per second.

#### More Details

###### Ring Recording

Keep in mind that the video stream is "live", and uses a ring recording style
where only a few minutes of video are ever stored on the RAM disk at any moment.
This means that this project alone is insufficient for storing recording of your
video stream.

[1]: https://www.raspberrypi.org
[2]: https://www.raspberrypi.org/documentation/raspbian/applications/camera.md
[3]: https://www.raspberrypi.org/documentation/usage/camera/raspicam/raspivid.md
[4]: https://www.raspberrypi.org/documentation/raspbian/
