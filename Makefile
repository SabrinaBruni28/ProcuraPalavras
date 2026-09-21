# Executa o aplicativo Flutter
run:
	flutter run

# Verifica se o ambiente Flutter está configurado corretamente
doctor:
	flutter doctor

# Lista os dispositivos disponíveis
devices:
	flutter devices

# Remove os arquivos temporários do projeto
clean:
	flutter clean

# Instala as dependências do projeto
pub:
	flutter pub get

# Gera o build apk
apk:
	flutter build apk --release

# Gera o build aab
aab:
	flutter build appbundle --release

# Gera o build web
web:
	flutter build web --release

# Gera o build linux
linux:
	flutter build linux --release

# Gera icones para cada tipo de plataforma
icones:
	dart run flutter_launcher_icons