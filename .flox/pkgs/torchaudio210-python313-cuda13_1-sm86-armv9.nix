# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA A40, RTX 3090 (SM86) — ARMv9 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "86"; isa = "armv9"; cudaVersion = "13_1"; }
