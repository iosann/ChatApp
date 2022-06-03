![Actions Status: test](https://github.com/iosann/ChatApp/actions/workflows/github.yml/badge.svg)

Приложение - чат.

- Архитектура SOA + MVC
- Интерфейс реализован без использования Storyboard
- При запуске приложения чаты загружаются из CoreData с использованием NSFetchedResultsController
- Параллельно чаты получаются из Firebase и записываются в CoreData в бэкграунде, вызывая обновление чатов на экране
- При нажатии на иконку профиля вызывается кастомный presentation transition
- Выбрать картинку профиля можно из загруженных через API pixabay.com с использованием URLSession, загрузка картинок не блокирует интерфейс, картинки при пролистывании отображаются корректно
- При нажатии на экран в области касания появляется поток эмблем
- Изменения данных профиля записываются в бэкграунде в FileManager с использованием GCD/Operation
- Анимирована смена темы и кнопка Save
- Для экрана профиля реализованы Unit и UI тесты, тест-планы
- Настроен локальный CI и CI на сервере с помощью Fastlane и GitHub Actions

<img src="https://github.com/iosann/ChatApp/blob/Screenshots/Screenshots/photo_2022-06-03%2017.47.58.jpeg" width="300"> <img src="https://github.com/iosann/ChatApp/blob/Screenshots/Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-06-03%20at%2016.26.37.png" width="300"> <img src="https://github.com/iosann/ChatApp/blob/Screenshots/Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-06-03%20at%2017.47.07.png" width="300">
<img src="https://github.com/iosann/ChatApp/blob/Screenshots/Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-06-03%20at%2018.04.18.png" width="300"> <img src="https://github.com/iosann/ChatApp/blob/Screenshots/Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-06-03%20at%2018.04.37.png" width="300"> <img src="https://github.com/iosann/ChatApp/blob/Screenshots/Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-06-03%20at%2016.26.13.png" width="300"> 
