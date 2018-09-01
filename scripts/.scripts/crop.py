#!/usr/bin/python3
# -*- coding: utf-8 -*-


import argparse
import sys
import os
from PyQt5.QtWidgets import QApplication, QWidget
from PyQt5.QtGui import QImage, QPainter, QPalette, QPixmap, QColor
from PyQt5.QtWidgets import (QWidget, QToolTip, QLabel, QMainWindow,
    QPushButton, QApplication,QSizePolicy)
from PyQt5.QtGui import QFont
from PyQt5.QtCore import QPoint, pyqtSignal, QObject
from PyQt5.QtPrintSupport import QPrintDialog, QPrinter
from PyQt5 import QtCore

class Communicate(QObject):
    cropImage = pyqtSignal('int','int','int','int')

class Overlay(QWidget):

    def __init__(self, parent, binpath):
        super().__init__(parent)
        sizePolicy = QSizePolicy()
        sizePolicy.setHorizontalPolicy(QSizePolicy.Maximum)
        sizePolicy.setVerticalPolicy(QSizePolicy.Maximum)
        #self.setSizePolicy(sizePolicy)
        self.setMouseTracking(True)

        self.on_selection = False
        self.selected = False
        self.c = Communicate()

        self.start_position = QPoint(0,0)
        self.last_position = QPoint(0,0)

        image = (
            b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
            b"\x00\x00\xFF\xFF\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00"
            b"\x00\x00\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\xFF\xFF\x00\x00"
            b"\x00\x00\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\xFF\xFF\x00\x00"
            b"\x00\x00\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\xFF\xFF\x00\x00"
            b"\x00\x00\xFF\xFF\x00\x00\x00\x00\x00\x00\x00\x00\xFF\xFF\x00\x00"
            b"\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00\xFF\xFF\x00\x00"
            b"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00")
        im = QImage(image, 8,8, QImage.Format_RGB16)
        im = im.scaled(64,64)
        self.crop = QPixmap()
        self.crop.convertFromImage(im)

    def insideSelection(self, point):
        width = self.last_position.x() - self.start_position.x()
        height = self.last_position.y() - self.start_position.y()

        return (    point.x() > self.start_position.x() and point.x() < self.start_position.x() + width and
                    point.y() > self.start_position.y() and point.y() < self.start_position.y() + height    )

    def mouseMoveEvent(self, event):

        if self.on_selection:
            self.last_position = event.pos()
            self.update()

    def mousePressEvent(self, QMouseEvent):

        if not self.insideSelection(QMouseEvent.pos()):
            self.on_selection = True
            self.selected = True
            self.start_position = QMouseEvent.pos()
            self.last_position = QMouseEvent.pos()
            self.update()

    def mouseDoubleClickEvent(self, QMouseEvent):
        if self.insideSelection(QMouseEvent.pos()):
            width = self.last_position.x() - self.start_position.x()
            height = self.last_position.y() - self.start_position.y()
            self.c.cropImage.emit(self.start_position.x(), self.start_position.y(), width,height)

    def mouseReleaseEvent(self, QMouseEvent):
        self.on_selection = False
        self.update()

    def enterEvent(self, event):
        return super().enterEvent(event)

    def leaveEvent(self, event):
        return super().enterEvent(event)

    def paintEvent(self, e):
        qp = QPainter()
        qp.begin(self)
        #self.drawWidget(qp)
        if self.selected:
            qp.setCompositionMode(QPainter.CompositionMode_HardLight)
            qp.setBrush(QColor(0, 0, 0, 128))
            qp.drawRect(0,0, self.width(), self.height())
            qp.setCompositionMode(QPainter.CompositionMode_Overlay)
            qp.setBrush(QColor(255, 255, 255, 255))

            width = self.last_position.x() - self.start_position.x()
            height = self.last_position.y()-self.start_position.y()

            qp.drawRect(self.start_position.x(), self.start_position.y(), width, height)
            qp.setCompositionMode(QPainter.CompositionMode_SourceOver)

            image_w = min([abs(width), abs(height), self.crop.width()]) #self.crop.width()
            image_h = image_w #self.crop.height()
            qp.drawPixmap(self.start_position.x() + width/2 - image_w/2, self.start_position.y() + height/2 - image_h/2, image_w, image_h, self.crop)

        qp.end()

        #qp = QPainter()
        #qp.begin(self)
        #qp.drawImage(0,0,image)
        #qp.end()

class Example(QMainWindow):
    def crop(self, x,y,width,height):
        x = round(x * 1/self.ratio)
        y = round(y * 1/self.ratio)
        width = round(width * 1/self.ratio)
        height = round(height * 1/self.ratio)

        from PIL import Image
        img = Image.open(self.imagepath)
        img2 = img.crop((x, y, x+width, y+height))

        basepath = os.path.dirname(self.imagepath)
        if basepath == "":
            basepath = "."
        img2.save(basepath + "/cropped" + os.path.basename(self.imagepath))
        self.close()

    def __init__(self, imagepath, binpath):
        super().__init__()

        QToolTip.setFont(QFont('SansSerif', 10))
        self.setToolTip('This is a <b>QWidget</b> widget')

        self.imageLabel = QLabel(self)
        self.imageLabel.setBackgroundRole(QPalette.Base)
        self.imageLabel.setSizePolicy(QSizePolicy.Ignored, QSizePolicy.Ignored)
        self.imageLabel.setScaledContents(True)

        self.overlay = Overlay(self.imageLabel, binpath)
        self.setCentralWidget(self.overlay)

        self.overlay.c.cropImage.connect(self.crop)
        #self.overlay.setSizePolicy(QSizePolicy.Maximum,QSizePolicy.Maximum)

        self.imagepath = imagepath
        image = QPixmap(imagepath)
        w = image.width()
        h = image.height()

        rec = QApplication.desktop().screenGeometry();
        dsk_h = rec.height();
        dsk_w = rec.width();

        wdw_w = min(0.7 * dsk_w, w) # Window's width 85% of screen's size
        self.ratio = wdw_w / w      # Storing the ratio for later use
        wdw_h = h * self.ratio      # A simple proportion to get the height, because we want to mantain the aspect ratio

        image = image.scaled(wdw_w, wdw_h, transformMode=QtCore.Qt.SmoothTransformation)

        self.imageLabel.setPixmap(image)
        self.imageLabel.adjustSize()

        self.setGeometry(dsk_w/2 - wdw_w/2, dsk_h/2 - wdw_h/2, wdw_w, wdw_h)
        self.setWindowTitle('Tooltips')
        self.show()


if __name__ == '__main__':
    bin_path = sys.argv[0]
    parser = argparse.ArgumentParser(description='Crop an image.')
    parser.add_argument('imagepath', nargs=1, type=str, help='Path to the image')
    args = parser.parse_args()

    app = QApplication(sys.argv)
    ex = Example(args.imagepath[0], os.path.dirname(bin_path))
    sys.exit(app.exec_())

#myPixmap = QtGui.QPixmap(_fromUtf8('image.jpg'))
#myScaledPixmap = myPixmap.scaled(self.label.size(), Qt.KeepAspectRatio)
#self.label.setPixmap(myScaledPixmap)
