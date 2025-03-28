 #!/bin/bash
   dirs=(
     "comp/freertos/FreeRTOS/Source/"
     "comp/exhost/"
     "comp/lwip/src"
     "comp/mbedtls/include"
     "comp/mbedtls/port"
     "comp/mbedtls/library"
     "comp/qurt"
     "comp/littlefs"
     "comp/wifi/core/wifi"
     "qccsdk"
     )
 
   prune_dirs=(
     "*/.*"
     "*/output/*"
     "*/sectools/*"
     "*/matter_demo/*"
     "*/Target_tools/*"
     "*/hwio/*"
     )
 
   file_types=(
     -name "*.c"
     -o -name "*.h"
     -o -name "*.gn"
     -o -name "*.gni"
     -o -name ".ld"
     -o -name "*.S"
     -o -name "Kconfig*"
     -o -name "*.conf"
     )
 
 output_file="file.list"
 
 #clear the output_file first
 > "$output_file"
 
 prune_args=()
 for pattern in "${prune_dirs[@]}"; do
   prune_args+=(-o -path "$pattern")
 done
 
 if [ ${#prune_args[@]} -gt 0 ]; then
   prune_args=("${prune_args[@]:1}")
   find_command=(
     find "${dirs[@]}"
     \( "${prune_args[@]}" \) -prune -o
     \( "${file_types[@]}" \) -type f -print
     )
else
  find=(
    find "${dirs[@]}"
    \( "${file_types[@]}" \) -type f -print
    )
fi

"${find_command[@]}" > "$output_file"

#add hwio for fermion
find  qccsdk/modules/core/common/hwio/fermionv2/TAPEOUT_07/ -type f >> "$output_file"
#generate GTAGS
#gtags -f file.list
