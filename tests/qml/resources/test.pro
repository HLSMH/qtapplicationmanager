AM_CONFIG = am-config.yaml
TEST_FILES = tst_resource.qml
TEST_APPS = app1 app2

DIRECTORIES = apps/app2/qml
FILES = am-config.yaml \
        apps/app1/icon.png apps/app1/info.yaml \
        apps/app2/icon.png apps/app2/info.yaml
DESTDIR = $$OUT_PWD
load(am-qml-testcase)

RESOURCE_SOURCE = systemuifile.qrc
load(generate-resource)

TEMPLATE = lib
TARGET = systemuiplugin
CONFIG += plugin
RESOURCES = systemuiplugin.qrc
