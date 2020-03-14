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

List<Caregiver> contactGroups = [
  Caregiver(
    name: 'Eva Britt',
    image: 'https://www.biography.com/.image/t_share/MTY2NTIzMDQzOTIzODk1NTM4/oprah-photo-by-vera-anderson_wireimage.jpg',
  ),
  Caregiver(
    name: 'James Franco',
    image: 'https://m.media-amazon.com/images/M/MV5BMjA4MzMzNDM5MF5BMl5BanBnXkFtZTgwMjQ0MDk0NDM@._V1_.jpg',
  ),
  Caregiver(
    name: 'Dave Franco',
    image: 'https://coolmenshair.com/wp-content/uploads/dave-franco-hairstyle.jpg',
  ),
];

List<Caregiver> careTaker = [
  Caregiver(
    name: 'Astrid Lindgren',
    image: 'https://images.prismic.io/astridlindgren/a0ca92e8555f3ba30d3fcf8da2f452992cf8f99d_astrid-lindgren-bertil-alvtegen.png?auto=compress,format',
  ),
];

List<Caregiver> caregivers = [
  Caregiver(
    name: 'Kevin Hart',
    image: 'https://m.media-amazon.com/images/M/MV5BMTY4OTAxMjkxN15BMl5BanBnXkFtZTgwODg5MzYyMTE@._V1_.jpg',
  ),
  Caregiver(
    name: 'Ellie Kemper',
    image: 'https://m.media-amazon.com/images/M/MV5BMjIzMDU3NzE4NV5BMl5BanBnXkFtZTcwODQyNTQzNA@@._V1_.jpg',
  ),
  Caregiver(
    name: 'Jenny Slate',
    image: 'https://new.static.tv.nu/19446248?forceFit=0&height=540&quality=50&width=400',
  ),
  Caregiver(
    name: 'Jennifer Aniston',
    image:
        'https://m.media-amazon.com/images/M/MV5BNjk1MjIxNjUxNF5BMl5BanBnXkFtZTcwODk2NzM4Mg@@._V1_UY1200_CR103,0,630,1200_AL_.jpg',
  ),
  Caregiver(
    name: 'Billie Eilish',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTsoLj966KjgjTt1Et6qcm3lZaDQ77mzMstoSmeLvwkKRq6CT2k',
  ),
];
