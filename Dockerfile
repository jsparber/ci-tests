FROM arm64v8/fedora:latest

VOLUME /build
WORKDIR /build
ENV FLATPAK_GL_DRIVERS=dummy

RUN dnf -y update && \
    dnf install -y flatpak flatpak-builder librsvg2 ostree fuse elfutils \
    dconf dbus-daemon git bzr xorg-x11-server-Xvfb dbus-x11 && \
    dnf clean all

RUN flatpak --supported-arches

RUN flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    flatpak remote-add gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo && \
    flatpak remote-add flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Add a machine-id as specified in the freedesktop spec:
# https://www.freedesktop.org/software/systemd/man/machine-id.html
# gnome-builder test suite depends on this
RUN cat /dev/urandom | tr -dc a-f0-9 | head -c32 > /etc/machine-id && echo "" >> /etc/machine-id

RUN flatpak install -y --noninteractive -vv gnome-nightly org.gnome.Sdk org.gnome.Platform
