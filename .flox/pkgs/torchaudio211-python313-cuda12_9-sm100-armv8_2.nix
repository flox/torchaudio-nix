# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA GB200 (SM100) — ARMv8.2 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "100"; isa = "armv8_2"; cudaVersion = "12_9"; }
