FROM debian:latest

# Installation des dépendances système
RUN apt-get update && apt-get install -y git wget unzip openjdk-17-jdk

# Installation de Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-8.0.2-bin.zip && \
    unzip gradle-8.0.2-bin.zip -d /opt && \
    rm gradle-8.0.2-bin.zip

# Configuration des variables d'environnement Gradle
ENV GRADLE_HOME=/opt/gradle-8.0.2
ENV PATH=$PATH:$GRADLE_HOME/bin

# Clonage des sources de GeckoView
RUN git clone https://github.com/AllanWang/GeckoView-Playground.git /geckoview
WORKDIR /geckoview

RUN ls /geckoview/*

# Installation du SDK Android

# RUN export ANDROID_SDK_ROOT=/usr/lib/android-sdk
# ENV ANDROID_SDK_ROOT=/opt/android-sdk
# ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools
# Installation des packages requis
RUN apt-get install -y android-sdk
RUN export ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
RUN unzip commandlinetools-linux-6609375_latest.zip -d cmdline-tools
RUN mkdir --parents "/usr/lib/android-sdk/cmdline-tools"
RUN mv cmdline-tools/* "/usr/lib/android-sdk/cmdline-tools/"
ENV PATH=/usr/lib/android-sdk/cmdline-tools/tools/bin:$PATH

RUN ls /usr/lib/android-sdk/*
RUN echo $ANDROID_SDK_ROOT
RUN echo $PATH 
# RUN apt-get install -y tree
# RUN tree /usr/lib/android-sdk/cmdline-tools/


# Accepter les licences
RUN yes | sdkmanager --licenses

# Installation des packages Android requis
RUN sdkmanager "platforms;android-31" "build-tools;31.0.0"

# RUN echo "sdk.dir = /usr/lib/android-sdk" >> /geckoview/local.properties

# Copie du fichier build.gradle personnalisé
# COPY build.gradle /geckoview/build.gradle

# RUN $GRADLE_HOME/bin/gradle wrapper
# RUN ls /geckoview/* 
# RUN cat /geckoview/gradle/wrapper/gradle-wrapper.properties

# Mettre à jour le fichier gradle-wrapper.properties
# RUN sed -i 's/gradle-4.4.1-all.zip/gradle-7.0.3-all.zip/' /geckoview/gradle/wrapper/gradle-wrapper.properties


# Compilation de GeckoView avec Gradle
# RUN ./gradlew

RUN ls /geckoview/* 
# RUN echo '<org.mozilla.geckoview.GeckoView xmlns:android="http://schemas.android.com/apk/res/android" android:id="@+id/geckoview" android:layout_width="fill_parent" android:layout_height="fill_parent" />' >> /geckoview/src/main/AndroidManifest.xml

RUN echo "sdk.dir = /usr/lib/android-sdk" >> /geckoview/local.properties
RUN $GRADLE_HOME/bin/gradle assemble

RUN ls /geckoview/app/build/outputs/apk/*

# Exécution du script de build
CMD ["echo", "Le build de GeckoView est terminé."]

