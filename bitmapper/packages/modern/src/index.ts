import path from "path";

import { BitmapsGenerator, SVGHandler } from "bibata-zebra-core";

const root = path.resolve(__dirname, "../../../../");
const svgDir = path.resolve(root, "svg", "modern");

const themeName = "Bibata-Zebra-Modern";
const trueAnimated = ["wait", "left_ptr_watch"];

const main = async () => {
  console.log("=>", themeName);

  const bitmapsDir = path.resolve(root, "bitmaps", themeName);
  const svg = new SVGHandler.SvgDirectoryParser(svgDir);

  const png = new BitmapsGenerator(bitmapsDir);
  const browser = await png.getBrowser();

  for (let { key, content } of svg.getStatic()) {
    console.log(" -> Saving", key, "...");
    await png.generateStatic(browser, content, key);
  }

  for (let { key, content } of svg.getAnimated()) {
    console.log(" -> Saving", key, "...");
    if (trueAnimated.includes(key)) {
      await png.generateAnimated(browser, content, key, { playbackRate: 0.45 });
    } else {
      await png.generateAnimated(browser, content, key);
    }
  }

  await browser.close();
};

main();
