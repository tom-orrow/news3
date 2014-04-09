Пример реализации краудсорсингового новостного портала
------------------------------------------------------

Суть: новостной сайт, где новости предлагают пользователи.

### Авторизация пользователей
Пользователь имеет возможность регистрироваться, входить и выходить из своего аккаунта.
Регистрация не обязательна для просмотра статей и написания комментариев.

### Статьи
Зарегистрированный пользователь имеет возможность написать статью.
Статья состоит из:
* заголовка
* анонса (краткое описание)
* тела статьи

В статье можно использовать разметку, вставлять картинки и видео с youtube.
Статьи относятся к категориям (политика, спорт, культура, …).
После создания статьи она ожидает модерации и не отображается на главной странице.
Статьи разбиваются на страницы.

### Комментарии
К статьям можно оставлять комментарии. К комментариям тоже можно оставлять комментарии.
Регистрация пользователя необязательна.

### Подписки
Зарегистрированный пользователь имеет возможность подписаться на новости определенной категории.
Если он это сделал, то ему на почту приходят письма с анонсами статей и ссылкой на полную статью.
Пользователь имеет возможность отписаться от рассылки, перейдя по прямой ссылке из письма.

### Админка
Админ должен имеет возможность удалить любую статью или комментарий (для него показывается ссылка на удаление около статьи/комментария).
Главная страница админки показывает:
* кол-во статей
* кол-во зарегистрированных пользователей

Разделы для редактирования и модерации статей.
После подтверждения или отклонения статьи автор получает соответствующее письмо.
