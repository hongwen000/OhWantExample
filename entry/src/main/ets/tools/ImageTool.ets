import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import fileUri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import wantConstant from '@ohos.app.ability.wantConstant';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';

function createImageFile(context: common.UIAbilityContext) : string | null {
  // 获取应用私有文件目录

  const filesDir = context.filesDir; // 应用私有目录
  const dirPath = `${filesDir}/Pictures`;
  const imgPath = `${dirPath}/img.jpg`;

  // 检查目录是否存在，如果不存在则创建
  try {
    fs.mkdirSync(dirPath);
  } catch (mkdirErr) {
    console.error('创建目录失败:', mkdirErr);
    return null;
  }

  // 创建并写入数据到 img.jpg 文件
  try {
    // 打开文件，如果不存在则创建
    const file = fs.openSync(imgPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
    // 写入一段内容至文件
    const data = 'This is test data'; // 这里可以是实际的图片数据
    const writeLen = fs.writeSync(file.fd, data);
    console.info(`写入文件的长度: ${writeLen}`);
    // 关闭文件
    fs.closeSync(file);
    return imgPath;
  } catch (err) {
    console.error('创建或写入 img.jpg 文件失败:', err);
    return null;
  }
}

export default createImageFile;