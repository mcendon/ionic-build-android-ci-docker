FROM ubuntu:16.04
MAINTAINER Mauro Cendon <mau.cendon@gmail.com>

# Install apt packages
RUN apt-get update && apt-get install -y git lib32stdc++6 lib32z1 npm nodejs nodejs-legacy s3cmd build-essential curl openjdk-8-jdk-headless sendemail libio-socket-ssl-perl libnet-ssleay-perl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install gdrive-cli 
# RUN cd /opt && curl -so /opt/gdrive-cli https://docs.google.com/uc?id=0B3X9GlR6EmbnLV92dHBpTkFhTEU&export=download
# RUN chmod +x /opt/gdrive-cli

# Install android SDK, tools and platforms 
RUN cd /opt && curl -o android-sdk.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar xzf android-sdk.tgz && rm android-sdk.tgz
ENV ANDROID_HOME /opt/android-sdk-linux
RUN echo 'y' | /opt/android-sdk-linux/tools/android update sdk -u -a -t platform-tools,build-tools-23.0.3,android-23,extra-android-support,extra-google-m2repository,extra-android-m2repository

# Accept Android Licence
RUN mkdir "${ANDROID_HOME}/licenses"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license" && echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"
RUN cat "${ANDROID_HOME}/licenses/android-sdk-license"

# Install npm packages
RUN npm install -g cordova@6.5.0 ionic@2.2.2 gulp && npm cache clean

# Create dummy app to build and preload gradle and maven dependencies
RUN cd / && echo 'n' | ionic start app && cd /app && ionic platform add android && ionic build android && rm -rf * .??* && rm /root/.android/debug.keystore

WORKDIR /app
