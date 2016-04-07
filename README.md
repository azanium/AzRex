# AzRex
H264 Recorder and Upload it to S3 bucket

How it will be uploaded on S3 is like this.

1. Project name will be in the form of dd-MM-yyyy-HH-mm-ss
2. Video name will in the form video1.mp4, video2.mp4 ... video5.mp4

For example:

Project name: 07-04-2016-07-32-38

The video paths on S3 will be: 
1. https://s3.amazonaws.com/azrex/videos/07-04-2016-07-32-38-video1.mp4
2. https://s3.amazonaws.com/azrex/videos/07-04-2016-07-32-38-video2.mp4
3. https://s3.amazonaws.com/azrex/videos/07-04-2016-07-32-38-video3.mp4
4. https://s3.amazonaws.com/azrex/videos/07-04-2016-07-32-38-video4.mp4
5. https://s3.amazonaws.com/azrex/videos/07-04-2016-07-32-38-video5.mp4
