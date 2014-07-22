Would the following be workable for you? I think it is more the way things are understood to be laid out in a typical pub package. Maybe other layouts like the one you have would work - but you are swimming upstream.

|-- LICENSE
|-- build.dart
|-- lib
|   |-- first_lib.dart
|   |-- second_lib.dart
|   '-- src
|       |-- first_lib
|       |   |-- first_lib_first_part.dart
|       |   '-- first_lib_second_part.dart
|       '-- second_lib
|           |-- second_lib_first_part.dart
|           '-- second_lib_second_part.dart
|-- pubspec.yaml
'-- web
    |-- single_app.css
    |-- single_app.dart
    '-- single_app.html

With this layout you do not need to worry about pub dependencies for inter-lib dependencies or app dependencies on those libs.