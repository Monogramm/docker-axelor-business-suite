#!/bin/bash
set -eo pipefail

declare -A pkg_install=(
	[jre8]='apt-get update -q; apt-get install -y --no-install-recommends '
	[jre8-alpine]='apk add --no-cache '
)

declare -A pkg_clean=(
	[jre8]='rm -rf \/var\/lib\/apt\/lists\/*; '
	[jre8-alpine]=''
)

# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
	[[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}


dockerRepo="monogramm/docker-axelor-business-suite"
# TODO Find a way to retrieve automatically the latest versions from GitHub
# latests=( $( curl -fsSL 'https://api.github.com/repos/axelor/abs-webapp/tags' |tac|tac| \
# 	grep -oE '[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
# 	sort -urV ) )
latests=( "4.2.3" )

# "4.0.x" Requires a ADK ~4.0.0, which isn't available
# "4.1.x" Requires a manual magement due to axelor-process-studio

# TODO Find a way to retrieve automatically the latest version from GitHub
adkVersion=4.1


# Remove existing images
echo "reset docker images"
find ./images -maxdepth 1 -type d -regextype sed -regex '\./images/[[:digit:]]\+\.[[:digit:]]\+' -exec rm -r '{}' \;

echo "update docker images"
travisEnv=
for latest in "${latests[@]}"; do
	version=$(echo "$latest" | cut -d. -f1-2)

	if [ -d "$version" ]; then
		continue
	fi

	# Only add versions >= 4.0
	if version_greater_or_equal "$version" "4.0"; then

		for variant in jre8 jre8-alpine; do
			echo "updating $latest [$version] $variant"

			# Create the version directory with a Dockerfile.
			dir="images/$version/$variant"
			mkdir -p "$dir"

			template="Dockerfile.template"
			cp "$template" "$dir/Dockerfile"

			# Replace the variables.
			sed -ri -e '
				s/%%VARIANT%%/'"$variant"'/g;
				s/%%ADK_VERSION%%/'"$adkVersion"'/g;
				s/%%ABS_VERSION%%/'"$latest"'/g;
				s/%%PKG_INSTALL%%/'"${pkg_install[$variant]}"'/g;
				s/%%PKG_CLEAN%%/'"${pkg_clean[$variant]}"'/g;
			' "$dir/Dockerfile"

			# Copy the shell scripts
			for name in entrypoint; do
				cp "docker-$name.sh" "$dir/$name.sh"
				chmod 755 "$dir/$name.sh"
			done

			travisEnv='\n    - VERSION='"$version"' VARIANT='"$variant$travisEnv"

			if [[ $1 == 'build' ]]; then
				tag="$version-$variant"
				echo "Build Dockerfile for ${tag}"
				docker build -t ${dockerRepo}:${tag} $dir
			fi
		done
	fi
done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
