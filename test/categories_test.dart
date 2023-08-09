import 'package:flutter_test/flutter_test.dart';
import 'package:hour_logger/categories.dart';
import 'dart:io';

void main(){
  test('canary', () => {
    expect(true, true)
  });

  test('readJsonFileToMap', () async {
    writeToFile('test.json', '{"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]}');
  
    expect((await readJsonFileToMap('${Directory.current.path}/test.json')).isNotEmpty, true);
  
    removeFile('test.json');
  });

  test('parseJsonMap', () async { 
    var map = {"categories":[{"name":"trash1", "subcategories":[]},{"name":"trash2", "subcategories":["rubbish"]}]};
    
    expect(parseJsonMap(map), {"trash1":[], "trash2":["rubbish"]});
  });
}

void writeToFile(String filename, dynamic data) async {
  var path = '${Directory.current.path}/$filename';

  var file = File(path);

  file.writeAsString(data);
}

void removeFile(String filename){
  var path = '${Directory.current.path}/$filename';

  File(path).delete();
}