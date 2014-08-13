// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

import 'dart:convert' show HtmlEscape;
import 'dart:html';
import 'dart:async';

import 'package:lawndart/lawndart.dart';

import 'utils.dart';

import 'dragdrop_api.dart';
import 'highlight_api.dart';


class Upload {
  FormElement _readForm;
  InputElement _fileInput;
  Element _dropZone;
  OutputElement _output;
  HtmlEscape sanitizer = new HtmlEscape();
  DragDrop _dragdrop;
  HighLight _highLight;

  Store _dbMedia = new Store('dbGridsterMedia', 'media');

  Upload() {
    _output = document.querySelector('#list');
    _readForm = document.querySelector('#read');
    _fileInput = document.querySelector('#files');
    _fileInput.onChange.listen((e) => _onFileInputChange());

    _dropZone = document.querySelector('#drop-zone');
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);
  }

  void setDragDrop(DragDrop dragdrop) {
    _dragdrop = dragdrop;
  }

  void setHighLight(HighLight highLight) {
    _highLight = highLight;
  }

  void _onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    event.dataTransfer.dropEffect = 'copy';
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    _dropZone.classes.remove('hover');
    _readForm.reset();
    _onFilesSelected(event.dataTransfer.files);
  }

  void _onFileInputChange() {
    _onFilesSelected(_fileInput.files);
  }

  void _onFilesSelected(List<File> files) {
    _output.nodes.clear();
    var list = new Element.tag('ul');
    for (var file in files) {
      var item = new Element.tag('li');

      // If the file is an image, read and display its thumbnail.
      if (file.type.startsWith('image')) {
        var thumbHolder = new Element.tag('span');
        var reader = new FileReader();
        reader.onLoad.listen((e) {
          var thumbnail = new ImageElement(src: reader.result);
          thumbnail.classes.add('thumb');
          thumbnail.title = sanitizer.convert(file.name);
          thumbHolder.nodes.add(thumbnail);
        });
        reader.readAsDataUrl(file);
        item.nodes.add(thumbHolder);
      }

      // For all file types, display some properties.
      var properties = new Element.tag('span');
      properties.innerHtml = (new StringBuffer('<strong>')
          ..write(sanitizer.convert(file.name))
          ..write('</strong> (')
          ..write(file.type != null ? sanitizer.convert(file.type) : 'n/a')
          ..write(') ')
          ..write(file.size)
          ..write(' bytes')// TODO(jason9t): Re-enable this when issue 5070 is resolved.
      // http://code.google.com/p/dart/issues/detail?id=5070
      // ..add(', last modified: ')
      // ..add(file.lastModifiedDate != null ?
      //       file.lastModifiedDate.toLocal().toString() :
      //       'n/a')
      ).toString();
      item.nodes.add(properties);
      list.nodes.add(item);
    }
    _output.nodes.add(list);

    List<Element> oldList = new List();
    try {
      oldList = document.querySelectorAll('#media-db ul li');
      oldList.forEach((e) => list.append(e));
    } catch (e) {

    }

    list.children.forEach((e) => _dragdrop.addEventsToColumn(e, _highLight));
    document.querySelector('#media-db').nodes.add(list);

    new Timer(new Duration(seconds: 5), () => _saveMedia());

  }

  void start() {
    try{
      _dbMedia.open().then((_) => _dbMedia.getByKey('media')).then((value) {
           _loadMedia(value.toString());
         });   
    }catch(e){}
   
  }

  void _loadMedia(String media) {
    if(media == 'null')return;
    document.querySelector('#media-db').setInnerHtml(media, treeSanitizer: new NullTreeSanitizer());
    
    List<Element> list = document.querySelectorAll('#media-db ul li');
    list.forEach((e) => _dragdrop.addEventsToColumn(e, _highLight));
    
  }

  void _saveMedia() {

    String uploadedMedia = document.querySelector('#media-db').innerHtml;
    print('saving media... : ' + uploadedMedia);
    if (uploadedMedia != 'null') {
      _dbMedia.open().then((_) => _dbMedia.save(uploadedMedia, 'media'));
    }
  }
}


void main() {
  new Upload();
}
