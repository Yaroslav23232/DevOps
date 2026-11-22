#!/usr/bin/env bash
set -euo pipefail

APP_USER="${APP_USER:-appuser}"
PROJECT_DIR="${PROJECT_DIR:-/opt/petclinic-src}"
APP_DIR="${APP_DIR:-/home/${APP_USER}/app}"
REPO_URL="${REPO_URL:-https://github.com/spring-projects/spring-petclinic.git}"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y openjdk-17-jdk git curl

if ! id -u "$APP_USER" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$APP_USER"
fi

mkdir -p "$PROJECT_DIR" "$APP_DIR"
chown -R "$APP_USER:$APP_USER" "$PROJECT_DIR" "$APP_DIR"

if [ ! -d "$PROJECT_DIR/.git" ]; then
  su - "$APP_USER" -c "git clone $REPO_URL $PROJECT_DIR"
else
  su - "$APP_USER" -c "git -C $PROJECT_DIR pull"
fi

su - "$APP_USER" -c "cd $PROJECT_DIR && ./mvnw clean package -DskipTests"

JAR_FILE=$(find "$PROJECT_DIR/target" -maxdepth 1 -name "*.jar" ! -name "*original*" | head -n 1)
cp "$JAR_FILE" "$APP_DIR/"
chown -R "$APP_USER:$APP_USER" "$APP_DIR"

cat <<EOF > /etc/profile.d/petclinic_app.sh
export APP_USER="$APP_USER"
export PROJECT_DIR="$PROJECT_DIR"
export APP_DIR="$APP_DIR"
export DB_NAME="${DB_NAME:-petclinic}"
export DB_USER="${DB_USER:-petclinic_user}"
export DB_PASS="${DB_PASS:-secretpassword}"
export SPRING_DATASOURCE_URL="jdbc:mysql://192.168.56.10:3306/${DB_NAME:-petclinic}"
export SPRING_DATASOURCE_USERNAME="${DB_USER:-petclinic_user}"
export SPRING_DATASOURCE_PASSWORD="${DB_PASS:-secretpassword}"
EOF
chmod +x /etc/profile.d/petclinic_app.sh
