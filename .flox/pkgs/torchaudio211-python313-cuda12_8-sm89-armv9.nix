# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA L40, RTX 4090 (SM89) — ARMv9 — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "89"; isa = "armv9"; cudaVersion = "12_8"; }
