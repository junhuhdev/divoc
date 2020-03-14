import 'package:divoc/models/caregiver.dart';
import 'package:divoc/models/feed.dart';

List<Feed> feeds = [
  Feed(
    name: 'Eva Britt',
    age: 87,
    gender: 'Female',
    image:
        'https://www.biography.com/.image/t_share/MTY2NTIzMDQzOTIzODk1NTM4/oprah-photo-by-vera-anderson_wireimage.jpg',
    city: 'Stockholm',
    state: 'Handen',
    severity: 5,
    type: 'medical',
    created: DateTime.now(),
  ),
  Feed(
    name: 'Gunnar Lindkvist',
    age: 77,
    gender: 'Male',
    image:
        'https://cached-images.bonnier.news/cms30/UploadedImages/2020/3/12/5b1025a4-429e-44c9-8485-b90397354586/bigOriginal.jpg?interpolation=lanczos-none&fit=around%7C480:270&crop=480:h;center,top&output-quality=80&output-format=auto',
    city: 'Stockholm',
    state: 'Solna',
    severity: 3,
    type: 'food',
    created: DateTime.now(),
  ),
  Feed(
    name: 'Peter Malmberg',
    age: 65,
    gender: 'Male',
    image: 'https://content.thriveglobal.com/wp-content/uploads/2019/05/47900764-6F79-4FD2-A0C7-00FD8D7B604C.jpeg',
    city: 'Stockholm',
    state: 'Älvsjö',
    severity: 5,
    type: 'food',
    created: DateTime.now(),
  ),
];

List<Caregiver> caregivers = [
  Caregiver(
    name: 'Kevin Hart',
    image: '',
  ),
  Caregiver(
    name: 'Ellie Kemper',
    image: '',
  ),
  Caregiver(
    name: 'Jenny Slate',
    image: '',
  ),
  Caregiver(
    name: 'Jenny Slate',
    image: '',
  ),
];