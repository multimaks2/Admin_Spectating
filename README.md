# Admin_Spectating
Ресурс для слежки за игроками
Для работы скрипта, необходим DGS - https://github.com/thisdp/dgs
Ресурс разрешается распростронять в пабликах, с единстенным условием: Указывать ссылку на Автора на Git-Hub
Данная версия предназначена для слежки за игроками, но для теста использовались Ped на стороне сервера, для того что-бы следить за игроками необходими внести изменения -
Открываем файл client.lua -> переходим на 38 сточку кода, и находим -> getElementsByType("ped") - нужно изменить на -> getElementsByType("player")
