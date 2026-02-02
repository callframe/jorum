#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 75a5702
array_find__0_v0() {
    local array_198=("${!1}")
    local value_199="${2}"
    index_201=0;
    for element_200 in "${array_198[@]}"; do
        if [ "$([ "_${value_199}" != "_${element_200}" ]; echo $?)" != 0 ]; then
            ret_array_find0_v0="${index_201}"
            return 0
        fi
        (( index_201++ )) || true
    done
    ret_array_find0_v0=-1
    return 0
}

# We cannot import `bash_version` from `env.ab` because it imports `text.ab` making a circular dependency.
# This is a workaround to avoid that issue and the import system should be improved in the future.
bash_version__13_v0() {
    local major_258=0
    local minor_259=0
    local patch_260=0
    major_258=${BASH_VERSINFO[0]}
        minor_259=${BASH_VERSINFO[1]}
        patch_260=${BASH_VERSINFO[2]}
    __status=$?
    ret_bash_version13_v0=("${major_258}" "${minor_259}" "${patch_260}")
    return 0
}

replace__14_v0() {
    local source_254="${1}"
    local search_255="${2}"
    local replace_256="${3}"
    # Here we use a command to avoid #646
    local result_257=""
    bash_version__13_v0 
    left_comp=("${ret_bash_version13_v0[@]}")
    right_comp=(4 3)
    local comp
    comp="$(
        # Compare if left array >= right array
        len_comp="$( (( "${#left_comp[@]}" < "${#right_comp[@]}" )) && echo "${#left_comp[@]}"|| echo "${#right_comp[@]}")"
        for (( i=0; i<len_comp; i++ )); do
            left="${left_comp[i]:-0}"
            right="${right_comp[i]:-0}"
            if (( "${left}" > "${right}" )); then
                echo 1
                exit
            elif (( "${left}" < "${right}" )); then
                echo 0
                exit
            fi
        done
        (( "${#left_comp[@]}" == "${#right_comp[@]}" || "${#left_comp[@]}" > "${#right_comp[@]}" )) && echo 1 || echo 0
)"
    if [ "${comp}" != 0 ]; then
        result_257="${source_254//"${search_255}"/"${replace_256}"}"
        __status=$?
    else
        result_257="${source_254//"${search_255}"/${replace_256}}"
        __status=$?
    fi
    ret_replace14_v0="${result_257}"
    return 0
}

split__18_v0() {
    local text_160="${1}"
    local delimiter_161="${2}"
    local result_162=()
    IFS="${delimiter_161}" read -rd '' -a result_162 < <(printf %s "$text_160")
    __status=$?
    ret_split18_v0=("${result_162[@]}")
    return 0
}

trim__24_v0() {
    local text_166="${1}"
    local result_167=""
    result_167="${text_166#${text_166%%[![:space:]]*}}"
    __status=$?
    result_167="${result_167%${result_167##*[![:space:]]}}"
    __status=$?
    ret_trim24_v0="${result_167}"
    return 0
}

starts_with__36_v0() {
    local text_169="${1}"
    local prefix_170="${2}"
    [[ "${text_169}" == "${prefix_170}"* ]]
    __status=$?
    ret_starts_with36_v0="$(( __status == 0 ))"
    return 0
}

slice__38_v0() {
    local text_179="${1}"
    local index_180="${2}"
    local length_181="${3}"
    local result_182=""
    if [ "$(( length_181 == 0 ))" != 0 ]; then
        local __length_3="${text_179}"
        length_181="$(( ${#__length_3} - index_180 ))"
    fi
    if [ "$(( length_181 <= 0 ))" != 0 ]; then
        ret_slice38_v0="${result_182}"
        return 0
    fi
    result_182="${text_179: ${index_180}: ${length_181}}"
    __status=$?
    ret_slice38_v0="${result_182}"
    return 0
}

char_at__39_v0() {
    local text_174="${1}"
    local index_175="${2}"
    local result_176=""
    result_176="${text_174:${index_175}:1}"
    __status=$?
    ret_char_at39_v0="${result_176}"
    return 0
}

file_exists__55_v0() {
    local path_156="${1}"
    [ -f "${path_156}" ]
    __status=$?
    ret_file_exists55_v0="$(( __status == 0 ))"
    return 0
}

file_read__56_v0() {
    local path_157="${1}"
    local command_4
    command_4="$(< "${path_157}")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_file_read56_v0=''
        return "${__status}"
    fi
    ret_file_read56_v0="${command_4}"
    return 0
}

file_write__57_v0() {
    local path_261="${1}"
    local content_262="${2}"
    local command_5
    command_5="$(printf '%s
' "${content_262}" > "${path_261}")"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_file_write57_v0=''
        return "${__status}"
    fi
    ret_file_write57_v0="${command_5}"
    return 0
}

panic__80_v0() {
    local msg_40="${1}"
    echo "PANIC: ${msg_40}"
    exit 1
}

unreachable__81_v0() {
    panic__80_v0 "Reached unreachable code."
}

gwd__82_v0() {
    local command_6
    command_6="$(pwd)"
    __status=$?
    if [ "${__status}" != 0 ]; then
        unreachable__81_v0 
    fi
    local res_41="${command_6}"
    ret_gwd82_v0="${res_41}"
    return 0
}

which__83_v0() {
    local cmd_351="${1}"
    local command_7
    command_7="$(which ${cmd_351})"
    __status=$?
    if [ "${__status}" != 0 ]; then
        ret_which83_v0=''
        return 1
    fi
    local res_352="${command_7}"
    ret_which83_v0="${res_352}"
    return 0
}

unquote__84_v0() {
    local input_173="${1}"
    local __length_8="${input_173}"
    if [ "$(( ${#__length_8} < 2 ))" != 0 ]; then
        ret_unquote84_v0="${input_173}"
        return 0
    fi
    char_at__39_v0 "${input_173}" 0
    local first_177="${ret_char_at39_v0}"
    local __length_9="${input_173}"
    char_at__39_v0 "${input_173}" "$(( ${#__length_9} - 1 ))"
    local last_178="${ret_char_at39_v0}"
    if [ "$(( $([ "_${first_177}" != "_\"" ]; echo $?) || $([ "_${first_177}" != "_'" ]; echo $?) ))" != 0 ]; then
        if [ "$([ "_${last_178}" == "_${first_177}" ]; echo $?)" != 0 ]; then
            ret_unquote84_v0=''
            return 1
        fi
        local __length_10="${input_173}"
        slice__38_v0 "${input_173}" 1 "$(( ${#__length_10} - 2 ))"
        ret_unquote84_v0="${ret_slice38_v0}"
        return 0
    fi
    ret_unquote84_v0="${input_173}"
    return 0
}

__LN_DELIMITER_3="
"
__KV_DELIMITER_4="="
__SKIP_PREFIX_5="#"
parse_config__86_v0() {
    local content_159="${1}"
    split__18_v0 "${content_159}" "${__LN_DELIMITER_3}"
    local _lines_163=("${ret_split18_v0[@]}")
    local vec_164=()
    for line_165 in "${_lines_163[@]}"; do
        trim__24_v0 "${line_165}"
        local trimmed_168="${ret_trim24_v0}"
        starts_with__36_v0 "${trimmed_168}" "${__SKIP_PREFIX_5}"
        local ret_starts_with36_v0__16_12="${ret_starts_with36_v0}"
        if [ "$(( ret_starts_with36_v0__16_12 || $([ "_${trimmed_168}" != "_" ]; echo $?) ))" != 0 ]; then
            continue
        fi
        split__18_v0 "${trimmed_168}" "${__KV_DELIMITER_4}"
        local parts_171=("${ret_split18_v0[@]}")
        trim__24_v0 "${parts_171[0]}"
        local key_172="${ret_trim24_v0}"
        trim__24_v0 "${parts_171[1]}"
        local ret_trim24_v0__22_31="${ret_trim24_v0}"
        unquote__84_v0 "${ret_trim24_v0__22_31}"
        __status=$?
        if [ "${__status}" != 0 ]; then
            continue
        fi
        local value_183="${ret_unquote84_v0}"
        vec_164+=("${key_172}" "${value_183}")
    done
    ret_parse_config86_v0=("${vec_164[@]}")
    return 0
}

parsed_find__87_v0() {
    local parsed_196=("${!1}")
    local key_197="${2}"
    array_find__0_v0 parsed_196[@] "${key_197}"
    local idx_202="${ret_array_find0_v0}"
    if [ "$(( idx_202 == -1 ))" != 0 ]; then
        ret_parsed_find87_v0=''
        return 1
    fi
    ret_parsed_find87_v0="${parsed_196[$(( idx_202 + 1 ))]}"
    return 0
}

__ASSEMBLER_LABEL_6="AS"
__ASSEMBLER_BINARY_7="clang"
__CCOMPILER_LABEL_8="CC"
__CCOMPILER_BINARY_9="clang"
__CCOMPILER_FLAGS_LABEL_10="CC_FLAGS"
__CCOMPILER_FLAGS_11="-ffreestanding -fno-builtin"
__PP_FLAGS_LABEL_12="PP_FLAGS"
__PP_FLAGS_13="-E -x assembler-with-cpp"
__LINKER_LABEL_14="LD"
__LINKER_BINARY_15="clang"
__LINKER_FLAGS_LABEL_16="LD_FLAGS"
__LINKER_FLAGS_17="-nostdlib -no-pie -Wl,--build-id=none"
__ARCHIVER_LABEL_18="AR"
__ARCHIVER_BINARY_19="ar"
__ARCHIVER_FLAGS_LABEL_20="AR_FLAGS"
__ARCHIVER_FLAGS_21="rcs"
__MKDIR_LABEL_22="MKDIR"
__MKDIR_BINARY_23="mkdir"
__MKDIR_FLAGS_LABEL_24="MKDIR_FLAGS"
__MKDIR_FLAGS_25="-p"
__RM_LABEL_26="RM"
__RM_BINARY_27="rm"
__RM_FLAGS_LABEL_28="RM_FLAGS"
__RM_FLAGS_29="-rf"
__COPY_LABEL_30="COPY"
__COPY_BINARY_31="cp"
__GRUB_LABEL_32="GRUB"
__GRUB_BINARY_33="grub-mkrescue"
__X86_64_ARCH_34="x86_64"
__I386_ARCH_35="i386"
__GET_X86_64_ARCH__94_v0() {
    __ret_GET_X86_64_ARCH94_v0="${__X86_64_ARCH_34}"
    return 0
}

__GET_I386_ARCH__95_v0() {
    __ret_GET_I386_ARCH95_v0="${__I386_ARCH_35}"
    return 0
}

attach_tool__96_v0() {
    local tc_348=("${!1}")
    local label_349="${2}"
    local binary_350="${3}"
    which__83_v0 "${binary_350}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        panic__80_v0 "Toolchain binary '${binary_350}' not found"
    fi
    local path_353="${ret_which83_v0}"
    local array_13=("${label_349}" "${path_353}")
    ret_attach_tool96_v0=("${tc_348[@]}" "${array_13[@]}")
    return 0
}

attach_tool__96_v1() {
    local tc_354=("${!1}")
    local label_355="${2}"
    local binary_356="${3}"
    which__83_v0 "${binary_356}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        panic__80_v0 "Toolchain binary '${binary_356}' not found"
    fi
    local path_357="${ret_which83_v0}"
    local array_15=("${label_355}" "${path_357}")
    ret_attach_tool96_v1=("${tc_354[@]}" "${array_15[@]}")
    return 0
}

clang_triple__97_v0() {
    local arch_358="${1}"
    ret_clang_triple97_v0="${arch_358}-unknown-none"
    return 0
}

attach_var__98_v0() {
    local tc_361=("${!1}")
    local label_362="${2}"
    local value_363="${3}"
    local array_17=("${label_362}" "${value_363}")
    ret_attach_var98_v0=("${tc_361[@]}" "${array_17[@]}")
    return 0
}

toolchain__99_v0() {
    local arch_346="${1}"
    local tc_347=()
    attach_tool__96_v0 tc_347[@] "${__ASSEMBLER_LABEL_6}" "${__ASSEMBLER_BINARY_7}"
    tc_347=("${ret_attach_tool96_v0[@]}")
    attach_tool__96_v1 tc_347[@] "${__CCOMPILER_LABEL_8}" "${__CCOMPILER_BINARY_9}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    clang_triple__97_v0 "${arch_346}"
    local ccompiler_triple_359="${ret_clang_triple97_v0}"
    local ccompiler_flags_360="${__CCOMPILER_FLAGS_11} --target=${ccompiler_triple_359}"
    attach_var__98_v0 tc_347[@] "${__CCOMPILER_FLAGS_LABEL_10}" "${ccompiler_flags_360}"
    tc_347=("${ret_attach_var98_v0[@]}")
    attach_var__98_v0 tc_347[@] "${__PP_FLAGS_LABEL_12}" "${__PP_FLAGS_13}"
    tc_347=("${ret_attach_var98_v0[@]}")
    attach_tool__96_v1 tc_347[@] "${__LINKER_LABEL_14}" "${__LINKER_BINARY_15}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    attach_var__98_v0 tc_347[@] "${__LINKER_FLAGS_LABEL_16}" "${__LINKER_FLAGS_17}"
    tc_347=("${ret_attach_var98_v0[@]}")
    attach_tool__96_v1 tc_347[@] "${__ARCHIVER_LABEL_18}" "${__ARCHIVER_BINARY_19}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    attach_var__98_v0 tc_347[@] "${__ARCHIVER_FLAGS_LABEL_20}" "${__ARCHIVER_FLAGS_21}"
    tc_347=("${ret_attach_var98_v0[@]}")
    attach_tool__96_v1 tc_347[@] "${__MKDIR_LABEL_22}" "${__MKDIR_BINARY_23}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    attach_var__98_v0 tc_347[@] "${__MKDIR_FLAGS_LABEL_24}" "${__MKDIR_FLAGS_25}"
    tc_347=("${ret_attach_var98_v0[@]}")
    attach_tool__96_v1 tc_347[@] "${__RM_LABEL_26}" "${__RM_BINARY_27}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    attach_var__98_v0 tc_347[@] "${__RM_FLAGS_LABEL_28}" "${__RM_FLAGS_29}"
    tc_347=("${ret_attach_var98_v0[@]}")
    attach_tool__96_v1 tc_347[@] "${__COPY_LABEL_30}" "${__COPY_BINARY_31}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    attach_tool__96_v1 tc_347[@] "${__GRUB_LABEL_32}" "${__GRUB_BINARY_33}"
    tc_347=("${ret_attach_tool96_v1[@]}")
    ret_toolchain99_v0=("${tc_347[@]}")
    return 0
}

gwd__82_v0 
__WORKING_DIR_42="${ret_gwd82_v0}"
__CONFIG_DIR_43="${__WORKING_DIR_42}/config"
__CONFIG_INPUT_44="${__CONFIG_DIR_43}/config.in"
__CONFIG_FILE_45="${__WORKING_DIR_42}/config.toml"
__CONFIG_HEADER_46="${__WORKING_DIR_42}/config.h"
__TOOLCHAIN_TEMPLATE_47="${__CONFIG_DIR_43}/toolchain.in"
__TOOLCHAIN_OUTPUT_48="${__WORKING_DIR_42}/toolchain.mk"
# Constants for configuration keys and values
__TARGET_ARCH_KEY_49="TARGET_ARCH"
__WORKING_DIR_KEY_50="WORKING_DIR"
__ARCH64_VAL_51="ARCH64"
__ARCH32_VAL_52="ARCH32"
# Constants for messages
__FAILED_TO_READ_PREFIX_53="Failed to read file at"
get_config__104_v0() {
    file_exists__55_v0 "${__CONFIG_FILE_45}"
    local ret_file_exists55_v0__29_12="${ret_file_exists55_v0}"
    if [ "$(( ! ret_file_exists55_v0__29_12 ))" != 0 ]; then
        panic__80_v0 "${__FAILED_TO_READ_PREFIX_53} ${__CONFIG_FILE_45}"
    fi
    file_read__56_v0 "${__CONFIG_FILE_45}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        unreachable__81_v0 
    fi
    local config_content_158="${ret_file_read56_v0}"
    parse_config__86_v0 "${config_content_158}"
    ret_get_config104_v0=("${ret_parse_config86_v0[@]}")
    return 0
}

template_key__105_v0() {
    local key_252="${1}"
    local prefix_253="${2}"
    ret_template_key105_v0="@${prefix_253}_${key_252}@"
    return 0
}

generate_from_template__106_v0() {
    local config_243=("${!1}")
    local template_244="${2}"
    local output_path_245="${3}"
    local prefix_246="${4}"
    local stride_247=2
    local __length_20=("${config_243[@]}")
    local iters_248="$(( ${#__length_20[@]} / stride_247 ))"
    local __range_start_249=0
    local __range_end_249="${iters_248}"
    local __dir_249=$(( ${__range_start_249} <= ${__range_end_249} ? 1 : -1 ))
    for (( i_249=${__range_start_249}; i_249 * ${__dir_249} < ${__range_end_249} * ${__dir_249}; i_249+=${__dir_249} )); do
        local key_250="${config_243[$(( i_249 * stride_247 ))]}"
        local value_251="${config_243[$(( $(( i_249 * stride_247 )) + 1 ))]}"
        template_key__105_v0 "${key_250}" "${prefix_246}"
        local ret_template_key105_v0__52_38="${ret_template_key105_v0}"
        replace__14_v0 "${template_244}" "${ret_template_key105_v0__52_38}" "${value_251}"
        local ret_replace14_v0__52_20="${ret_replace14_v0}"
        template_244="${ret_replace14_v0__52_20}"
done
    file_write__57_v0 "${output_path_245}" "${template_244}"
    __status=$?
    if [ "${__status}" != 0 ]; then
        panic__80_v0 "${__FAILED_TO_READ_PREFIX_53} ${output_path_245}"
    fi
}

handle_arch__107_v0() {
    local config_206=("${!1}")
    local target_arch_207="${2}"
    __GET_X86_64_ARCH__94_v0 
    local __ret_GET_X86_64_ARCH94_v0__61_23="${__ret_GET_X86_64_ARCH94_v0}"
    if [ "$([ "_${target_arch_207}" != "_${__ret_GET_X86_64_ARCH94_v0__61_23}" ]; echo $?)" != 0 ]; then
        config_206+=("${__ARCH64_VAL_51}" "1" "${__ARCH32_VAL_52}" "0")
    fi
    __GET_I386_ARCH__95_v0 
    local __ret_GET_I386_ARCH95_v0__68_23="${__ret_GET_I386_ARCH95_v0}"
    if [ "$([ "_${target_arch_207}" != "_${__ret_GET_I386_ARCH95_v0__68_23}" ]; echo $?)" != 0 ]; then
        config_206+=("${__ARCH64_VAL_51}" "0" "${__ARCH32_VAL_52}" "1")
    fi
    ret_handle_arch107_v0=("${config_206[@]}")
    return 0
}

get_config__104_v0 
config_184=("${ret_get_config104_v0[@]}")
parsed_find__87_v0 config_184[@] "${__TARGET_ARCH_KEY_49}"
__status=$?
if [ "${__status}" != 0 ]; then
    panic__80_v0 "Target architecture not found in configuration."
fi
target_arch_203="${ret_parsed_find87_v0}"
handle_arch__107_v0 config_184[@] "${target_arch_203}"
config_184=("${ret_handle_arch107_v0[@]}")
file_exists__55_v0 "${__CONFIG_INPUT_44}"
ret_file_exists55_v0__86_12="${ret_file_exists55_v0}"
if [ "$(( ! ret_file_exists55_v0__86_12 ))" != 0 ]; then
    panic__80_v0 "${__FAILED_TO_READ_PREFIX_53} ${__CONFIG_INPUT_44}"
fi
file_read__56_v0 "${__CONFIG_INPUT_44}"
__status=$?
if [ "${__status}" != 0 ]; then
    unreachable__81_v0 
fi
template_208="${ret_file_read56_v0}"
generate_from_template__106_v0 config_184[@] "${template_208}" "${__CONFIG_HEADER_46}" "CONFIG"
toolchain__99_v0 "${target_arch_203}"
tc_364=("${ret_toolchain99_v0[@]}")
file_exists__55_v0 "${__TOOLCHAIN_TEMPLATE_47}"
ret_file_exists55_v0__97_12="${ret_file_exists55_v0}"
if [ "$(( ! ret_file_exists55_v0__97_12 ))" != 0 ]; then
    panic__80_v0 "${__FAILED_TO_READ_PREFIX_53} ${__TOOLCHAIN_TEMPLATE_47}"
fi
attach_var__98_v0 tc_364[@] "${__TARGET_ARCH_KEY_49}" "${target_arch_203}"
tc_364=("${ret_attach_var98_v0[@]}")
attach_var__98_v0 tc_364[@] "${__WORKING_DIR_KEY_50}" "${__WORKING_DIR_42}"
tc_364=("${ret_attach_var98_v0[@]}")
file_read__56_v0 "${__TOOLCHAIN_TEMPLATE_47}"
__status=$?
if [ "${__status}" != 0 ]; then
    unreachable__81_v0 
fi
toolchain_template_365="${ret_file_read56_v0}"
generate_from_template__106_v0 tc_364[@] "${toolchain_template_365}" "${__TOOLCHAIN_OUTPUT_48}" "TOOLCHAIN"
