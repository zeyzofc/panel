
FROM alpine:latest
RUN apk update && apk add bash tar xz
WORKDIR /myapp
ENV PORT=3000
ARG USER=1000
ARG PGRST="postgrest"
ARG CONF="${PGRST}.conf"
ARG ENV_TO_CONF="env-to-config"
ARG BIN="/bin/"
ARG VERSION="9.0.1"
ARG FILE="${PGRST}-v${VERSION}-linux-static-x64.tar.xz"

# The static PostgREST executable has no runtime dependencies, so it's all we
# need to include for running the application.
ADD https://github.com/PostgREST/${PGRST}/releases/download/v${VERSION}/${FILE} .
RUN tar -xvf ${FILE} && chown ${USER}:${USER} ${PGRST} && rm -f ${FILE} && mv ${PGRST} ${BIN}
# Not allowed by Heroku
# EXPOSE ${PORT}
# SO PARSING VARS TO FILE
ADD ${ENV_TO_CONF} ${BIN}
RUN touch ${CONF} && chown ${USER}:${USER} ${CONF}
# RUN /bin/sed -i "s/\${PORT}/${PORT}/" postgrest.conf

# This is the user id that Docker will run our image under by default. Note
# that we don't actually add the user to `/etc/passwd` or `/etc/shadow`. This
# means that tools like whoami would not work properly, but we don't include
# those in the image anyway. Not adding the user has the benefit that the image
# can be run under any user you specify.
USER ${USER}

# CMD is not getting through a shell can not interpolate ARG vars
CMD ["env-to-config", "postgrest", "postgrest.conf"]
