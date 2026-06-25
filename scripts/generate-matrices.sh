#!/usr/bin/env bash
set -euo pipefail

# Generate per-TorchAudio/CUDA build matrix documentation.

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$REPO_DIR/docs/matrices"
mkdir -p "$OUT_DIR"

# ── GPU metadata ──────────────────────────────────────────────────────
declare -A SM_ARCH_NAME=(
  [61]="Pascal" [70]="Volta" [75]="Turing" [80]="Ampere" [86]="Ampere"
  [89]="Ada Lovelace" [90]="Hopper" [100]="Blackwell"
  [103]="Blackwell Ultra" [110]="DRIVE Thor" [120]="Vera Rubin"
  [121]="Vera Rubin Ultra"
)
declare -A SM_GPU_NAMES=(
  [61]="GTX 1070, 1080, 1080 Ti, P40" [70]="V100, Titan V"
  [75]="T4, RTX 2080 Ti" [80]="A100, A30"
  [86]="A40, RTX 3090" [89]="L40, RTX 4090"
  [90]="H100, H200, L40S" [100]="B200, GB200"
  [103]="B300, GB300" [110]="DRIVE Thor"
  [120]="R100, RTX 5090" [121]="R100 Ultra"
)
declare -A SM_AARCH64_GPU_NAMES=(
  [80]="A100 (ARM)" [90]="GH200" [100]="GB200" [103]="GB300"
)

declare -A ISA_DISPLAY=(
  [avx]="AVX" [avx2]="AVX2" [avx512]="AVX-512"
  [avx512bf16]="AVX-512 BF16" [avx512vnni]="AVX-512 VNNI"
  [armv8_2]="ARMv8.2" [armv9]="ARMv9"
)

declare -A CUDA_DRIVER=( [12_8]="550" [12_9]="560" [13_0]="580" [13_1]="590" )
declare -A CUDA_DISPLAY=( [12_8]="12.8" [12_9]="12.9" [13_0]="13.0" [13_1]="13.1" )

X86_ISAS=(avx avx2 avx512 avx512bf16 avx512vnni)
SM61_ISAS=(avx avx2)

declare -A SM_AARCH64_ISAS=(
  [70]="armv8_2 armv9" [75]="armv8_2 armv9"
  [80]="armv8_2 armv9" [86]="armv8_2 armv9"
  [89]="armv8_2 armv9" [90]="armv8_2 armv9"
  [100]="armv8_2 armv9" [103]="armv8_2 armv9"
  [110]="armv8_2 armv9" [120]="armv8_2 armv9"
  [121]="armv8_2 armv9"
)

declare -A SM_AARCH64_ONLY=( [110]=1 [121]=1 )

declare -A SM_CUDA_VERSIONS=(
  [61]="12_8 12_9"
  [103]="12_9 13_0 13_1"
  [110]="13_0 13_1"
  [121]="13_0 13_1"
)

ALL_SMS=(61 70 75 80 86 89 90 100 103 110 120 121)

# ── TorchAudio full versions ──────────────────────────────────────────
declare -A TA_FULL_VERSION=( [2.10]="2.10.0" [2.11]="2.11.0" )
declare -A TA_PT_VERSION=(   [2.10]="2.10.0" [2.11]="2.11.0" )

declare -A USE_CASE_SUFFIX=(
  [avx]="legacy x86 CPUs"
  [avx2]="broad x86 compatibility"
  [avx512]="general datacenter"
  [avx512bf16]="BF16 mixed-precision"
  [avx512vnni]="INT8 quantized inference"
)
declare -A ARM_USE_CASE=(
  [armv8_2]="Graviton2" [armv9]="Grace/Graviton3+"
)
declare -A ARM_USE_CASE_AARCH64_ONLY=(
  [armv8_2]="older ARM" [armv9]="modern ARM"
)

# ── Build matrix combos ──────────────────────────────────────────────
# Format: "taVer:cudaVer:pyVers"
MATRIX_COMBOS=(
  "2.10:12_8:313"
  "2.10:12_9:313"
  "2.10:13_0:313"
  "2.10:13_1:313"
  "2.11:12_8:313"
  "2.11:12_9:313"
  "2.11:13_0:313"
  "2.11:13_1:313"
)

ta_short() { echo "$1" | tr -d '.'; }

sm_supports_cuda() {
  local sm="$1" cuda_ver="$2"
  if [[ -n "${SM_CUDA_VERSIONS[$sm]:-}" ]]; then
    local allowed
    read -ra allowed <<< "${SM_CUDA_VERSIONS[$sm]}"
    for v in "${allowed[@]}"; do
      [[ "$v" == "$cuda_ver" ]] && return 0
    done
    return 1
  fi
  return 0
}

count=0

for combo in "${MATRIX_COMBOS[@]}"; do
  IFS=: read -r ta_ver cuda_ver py_vers_str <<< "$combo"
  read -ra py_vers <<< "$py_vers_str"

  ta_full="${TA_FULL_VERSION[$ta_ver]}"
  pt_full="${TA_PT_VERSION[$ta_ver]}"
  ta_s=$(ta_short "$ta_ver")
  cuda_disp="${CUDA_DISPLAY[$cuda_ver]}"
  cuda_drv="${CUDA_DRIVER[$cuda_ver]}"

  py_display=""
  for py in "${py_vers[@]}"; do
    [[ -n "$py_display" ]] && py_display+=", "
    py_display+="${py:0:1}.${py:1}"
  done

  if [[ ${#py_vers[@]} -eq 1 ]]; then
    pkg_note="Package names follow \`torchaudio${ta_s}-python${py_vers[0]}-cuda${cuda_ver}-sm{sm}-{isa}\`."
  else
    py_keys=""
    for i in "${!py_vers[@]}"; do
      if [[ $i -gt 0 ]]; then
        if [[ $i -eq $((${#py_vers[@]} - 1)) ]]; then
          py_keys+=", or "
        else
          py_keys+=", "
        fi
      fi
      py_keys+="\`${py_vers[$i]}\`"
    done
    pkg_note="Package names follow \`torchaudio${ta_s}-python{py}-cuda${cuda_ver}-sm{sm}-{isa}\` where \`{py}\` is ${py_keys}."
  fi

  outfile="$OUT_DIR/torchaudio-${ta_ver}-cuda-${cuda_disp}.md"

  {
    echo "# TorchAudio ${ta_ver} + CUDA ${cuda_disp} — Build Matrix"
    echo ""
    echo "- **TorchAudio**: ${ta_full}"
    echo "- **PyTorch** (matching torch ABI): ${pt_full} — provided by sibling repo \`pytorch-nix\`"
    echo "- **CUDA**: ${cuda_disp}"
    echo "- **Min driver**: ${cuda_drv}+"
    echo "- **Python versions**: ${py_display}"
    echo ""
    echo "${pkg_note}"
    echo ""
    echo "## GPU Variants"

    excluded=()

    for sm in "${ALL_SMS[@]}"; do
      if ! sm_supports_cuda "$sm" "$cuda_ver"; then
        read -ra allowed_parts <<< "${SM_CUDA_VERSIONS[$sm]}"
        last_allowed="${allowed_parts[-1]}"
        first_allowed="${allowed_parts[0]}"
        cv_num=$(echo "$cuda_ver" | awk -F_ '{ printf "%d%02d", $1, $2 }')
        last_num=$(echo "$last_allowed" | awk -F_ '{ printf "%d%02d", $1, $2 }')
        if (( cv_num > last_num )); then
          excluded+=("SM${sm} (capped at CUDA ${CUDA_DISPLAY[$last_allowed]})")
        else
          excluded+=("SM${sm} (requires CUDA ${CUDA_DISPLAY[$first_allowed]}+)")
        fi
        continue
      fi

      echo ""

      arch_name="${SM_ARCH_NAME[$sm]}"
      gpu_names="${SM_GPU_NAMES[$sm]}"
      if [[ -n "${SM_AARCH64_ONLY[$sm]:-}" ]]; then
        echo "### SM${sm} — ${arch_name} (aarch64-only)"
      else
        echo "### SM${sm} — ${arch_name} (${gpu_names})"
      fi
      echo ""
      echo "| ISA | Package Name | Use Case |"
      echo "|-----|-------------|----------|"

      if [[ -z "${SM_AARCH64_ONLY[$sm]:-}" ]]; then
        if [[ "$sm" == "61" ]]; then
          isas=("${SM61_ISAS[@]}")
        else
          isas=("${X86_ISAS[@]}")
        fi

        for isa in "${isas[@]}"; do
          use_case="${gpu_names} + ${USE_CASE_SUFFIX[$isa]}"
          echo "| ${ISA_DISPLAY[$isa]} | \`...-sm${sm}-${isa}\` | ${use_case} |"
        done
      fi

      if [[ -n "${SM_AARCH64_ISAS[$sm]:-}" ]]; then
        read -ra arm_isas <<< "${SM_AARCH64_ISAS[$sm]}"

        if [[ -n "${SM_AARCH64_GPU_NAMES[$sm]:-}" ]]; then
          arm_gpu="${SM_AARCH64_GPU_NAMES[$sm]}"
        else
          arm_gpu="${SM_GPU_NAMES[$sm]}"
        fi

        for isa in "${arm_isas[@]}"; do
          if [[ -n "${SM_AARCH64_ONLY[$sm]:-}" ]]; then
            suffix="${ARM_USE_CASE_AARCH64_ONLY[$isa]}"
          else
            suffix="${ARM_USE_CASE[$isa]}"
          fi
          use_case="${arm_gpu} + ${suffix}"
          echo "| ${ISA_DISPLAY[$isa]} | \`...-sm${sm}-${isa}\` | ${use_case} |"
        done
      fi
    done

    if [[ ${#excluded[@]} -gt 0 ]]; then
      echo ""
      note="*Not available at CUDA ${cuda_disp}: "
      for i in "${!excluded[@]}"; do
        [[ $i -gt 0 ]] && note+=", "
        note+="${excluded[$i]}"
      done
      note+="*"
      echo "$note"
    fi
  } > "$outfile"

  count=$((count + 1))
done

echo "Generated ${count} matrix files in ${OUT_DIR}"
