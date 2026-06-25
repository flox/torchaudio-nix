# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA A40, RTX 3090 (SM86) — ARMv9 — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "86"; isa = "armv9"; cudaVersion = "12_8"; }
