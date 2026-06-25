# GPU metadata: SM architecture → capability, GPU names, ISA restrictions, CUDA version support.
# Used by mkPyTorch.nix for CUDA variant configuration and by generate-variants.sh for matrix generation.
{
  "61" = {
    capability = "6.1";
    archName = "Pascal";
    gpuNames = "GTX 1070, 1080, 1080 Ti, P40";
    allowedISAs = [ "avx" "avx2" ];
    # CUDA 13.0 nvcc removed compute_61; Pascal capped at CUDA 12.9.
    cudaVersions = [ "12_8" "12_9" ];
  };
  "70" = {
    capability = "7.0";
    archName = "Volta";
    gpuNames = "V100, Titan V";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
  "75" = {
    capability = "7.5";
    archName = "Turing";
    gpuNames = "T4, RTX 2080 Ti";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
  "80" = {
    capability = "8.0";
    archName = "Ampere";
    gpuNames = "A100, A30";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
    aarch64GpuNames = "A100 (ARM)";
  };
  "86" = {
    capability = "8.6";
    archName = "Ampere";
    gpuNames = "A40, RTX 3090";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
  "89" = {
    capability = "8.9";
    archName = "Ada Lovelace";
    gpuNames = "L40, RTX 4090";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
  "90" = {
    capability = "9.0";
    archName = "Hopper";
    gpuNames = "H100, H200, L40S";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
    aarch64GpuNames = "GH200";
  };
  "100" = {
    capability = "10.0";
    archName = "Blackwell";
    gpuNames = "B200, GB200";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
    aarch64GpuNames = "GB200";
  };
  "103" = {
    capability = "10.3";
    archName = "Blackwell Ultra";
    gpuNames = "B300, GB300";
    allowedISAs = null;
    cudaVersions = [ "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
    aarch64GpuNames = "GB300";
  };
  "110" = {
    capability = "11.0";
    archName = "DRIVE Thor";
    gpuNames = "DRIVE Thor";
    allowedISAs = [];  # aarch64-only (no x86 variants)
    cudaVersions = [ "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
  "120" = {
    capability = "12.0";
    archName = "Vera Rubin";
    gpuNames = "R100, RTX 5090";
    allowedISAs = null;
    cudaVersions = [ "12_8" "12_9" "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
  "121" = {
    capability = "12.1";
    archName = "Vera Rubin Ultra";
    gpuNames = "R100 Ultra";
    allowedISAs = [];  # aarch64-only (no x86 variants)
    cudaVersions = [ "13_0" "13_1" ];
    aarch64ISAs = [ "armv8_2" "armv9" ];
  };
}
