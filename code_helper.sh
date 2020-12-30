CODE_INSTALL_CMD=""
CMAKE=cmake

function help()
{
		echo "****************** code server help ******************"
		echo ""
		echo "sh $0 install   --- install code webide"
		echo "sh $0 commands [dir]   --- copy compile_commands.json"
		echo "sh $0 plugin [src] [dst]  --- install plugins"
		echo "sh $0 generate src [dst]    --- generate an index file"
		echo ""
		echo "************************ end **************************"
		exit 0
}

function do_install() {
		echo "installing code server"
		$CODE_INSTALL_CMD
		if [ "$?" = "0" ]; then
				echo "installed successful"
		else
				echo "installed fialed"
				exit -1
		fi
}

function do_plugin() {
		local src="extensions"
		local dst="$HOME/.local/share/code-server/extensions"
		if [ -d "$src" ]; then
				echo "installing plugins"
		else
				echo "install nothing"
				exit -1
		fi
		if [ -d "$dst" ]; then
				echo "$dst existed"
		else
				echo "mkdir -p $dst"
				mkdir -p $dst
		fi
		cp -rf $src/* $dst
}

function do_commands() {
		echo "copying compile_commands.json"
		local file="compile_commands.json"
		local dir=".vscode"
		if [ ! "$2" = "" ]; then
				dir="$2/.vscode"
		fi
		if [ ! -d "$dir" ]; then
				mkdir -p "$dir"
		fi
		if [ -f "$file" ]; then
				cp "$file" "$dir"
		else
				echo "no $file"
		fi
}

function do_generate() {
		echo "generate index file"
		local src="."
		local dst="."
		if [ ! "$2" = "" ]; then
				src="$2"
		fi
		if [ ! "$3" = "" ]; then
				dst="$3"
		fi
		$CMAKE -DCMAKE_EXPORT_COMPILE_COMMANDS=YES "$dir"
		if [ ! "$?" = "0" ]; then 
				echo "cmake fialed"
		else
				do_commands $dir
		fi
}

function main() {
		if [ "$1" = "" ];
		then
				help
		fi
		case "$1" in
				"install")
				do_install
				;;
				"plugin")
				do_plugin
				;;
				"commands")
				do_commands
				;;
				"generate")
				do_generate
				;;
				*)
				help
				;;
		esac
}

main $@
