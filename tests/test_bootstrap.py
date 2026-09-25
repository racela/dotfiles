"""Offline integration tests: real Stow, isolated HOME, no package installs."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class BootstrapTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles test ")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home"
        self.home.mkdir()
        self.bin = Path(self.temp.name) / "bin"
        self.bin.mkdir()
        # Exercise macOS routing on either CI host without touching /etc/os-release.
        uname = self.bin / "uname"
        uname.write_text('#!/bin/sh\nprintf "Darwin\\n"\n')
        uname.chmod(0o755)
        self.env = dict(os.environ, HOME=str(self.home),
                        PATH=f"{self.bin}:{os.environ['PATH']}",
                        XDG_CONFIG_HOME=str(self.home / ".config"))

    def bootstrap(self, *args, ok=True):
        result = subprocess.run(
            ["bash", str(ROOT / "bootstrap.sh"), "--skip-packages", "--skip-plugins", *args],
            env=self.env, cwd="/tmp", text=True, capture_output=True)
        if ok:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def test_install_repeat_and_unlink(self):
        self.bootstrap()
        self.assertEqual((self.home / ".zshrc").resolve(), ROOT / "mac/.zshrc")
        self.assertTrue((self.home / ".config/nvim/init.lua").is_symlink())
        self.assertTrue((self.home / ".config/zsh/rc.zsh").is_symlink())
        self.assertFalse((self.home / ".config/spicetify").exists())
        self.bootstrap()
        unrelated = self.home / ".config/keep-me"
        unrelated.write_text("mine")
        self.bootstrap("--unlink")
        self.assertFalse((self.home / ".zshrc").is_symlink())
        self.assertFalse((self.home / ".config/nvim/init.lua").is_symlink())
        self.assertEqual(unrelated.read_text(), "mine")

    def test_platform_conflict_prevents_all_links(self):
        (self.home / ".zshrc").write_text("keep my shell")
        self.bootstrap(ok=False)
        self.assertEqual((self.home / ".zshrc").read_text(), "keep my shell")
        self.assertFalse((self.home / ".tmux.conf").exists())

    def test_common_conflict_preserves_file(self):
        target = self.home / ".config/nvim"
        target.mkdir(parents=True)
        (target / "init.lua").write_text("-- mine")
        self.bootstrap(ok=False)
        self.assertEqual((target / "init.lua").read_text(), "-- mine")
        self.assertFalse((self.home / ".zshrc").exists())

    def test_dry_run_does_not_write(self):
        self.bootstrap("--dry-run")
        self.assertEqual(list(self.home.iterdir()), [])

    def test_invalid_options(self):
        self.bootstrap("--unknown", ok=False)
        self.bootstrap("--desktop", ok=False)
        self.assertEqual(list(self.home.iterdir()), [])

    def test_custom_xdg_rejected(self):
        self.env["XDG_CONFIG_HOME"] = str(self.home / "elsewhere")
        self.bootstrap(ok=False)
        self.assertEqual(list(self.home.iterdir()), [])

    @unittest.skipUnless(Path("/etc/os-release").exists() and
                         'ID=arch' in Path("/etc/os-release").read_text(),
                         "Native Arch desktop routing requires Arch")
    def test_arch_desktop_and_exclusions(self):
        (self.bin / "uname").write_text('#!/bin/sh\nprintf "Linux\\n"\n')
        self.bootstrap("--desktop")
        self.assertTrue((self.home / ".config/hypr/hyprland.lua").is_symlink())
        self.assertTrue((self.home / ".config/backgrounds/murky_peaks.jpg").is_symlink())
        self.assertFalse((self.home / ".config/spicetify").exists())
        self.assertFalse((self.home / ".config/nightTab").exists())
        self.bootstrap("--desktop")
        self.bootstrap("--desktop", "--unlink")
        self.assertFalse((self.home / ".config/hypr/hyprland.lua").is_symlink())

    def test_plugin_lock_with_offline_repository(self):
        fixture = Path(self.temp.name) / "fixture"
        (fixture / "scripts").mkdir(parents=True)
        shutil.copy(ROOT / "scripts/install-plugins.sh", fixture / "scripts")
        source = Path(self.temp.name) / "upstream"
        subprocess.run(["git", "init", "-q", str(source)], check=True)
        subprocess.run(["git", "-C", str(source), "-c", "user.name=Test", "-c",
                        "user.email=test@example.invalid", "commit", "-qm", "fixture",
                        "--allow-empty"], check=True)
        sha = subprocess.check_output(["git", "-C", str(source), "rev-parse", "HEAD"], text=True).strip()
        # Relative local URL avoids whitespace in the lock's URL column.
        (fixture / "plugins.lock").write_text(f".test-plugin ../upstream {sha}\n")
        command = ["bash", str(fixture / "scripts/install-plugins.sh")]
        for _ in range(2):
            subprocess.run(command, cwd=fixture, env=self.env, check=True, capture_output=True)
        installed = self.home / ".test-plugin"
        actual = subprocess.check_output(["git", "-C", str(installed), "rev-parse", "HEAD"], text=True).strip()
        self.assertEqual(actual, sha)
        (installed / "local-work").write_text("keep")
        subprocess.run(command, cwd=fixture, env=self.env, check=True, capture_output=True)
        self.assertEqual((installed / "local-work").read_text(), "keep")


if __name__ == "__main__":
    unittest.main()
