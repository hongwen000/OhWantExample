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

export default class TestExplicitIntent extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    this.createImageFileAndSendWant();
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }


  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/ExplicitIntentIndex', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  // 创建 img.jpg 文件并发送 Want
  private createImageFileAndSendWant(): void {
    // 创建 img.jpg 文件用于测试
    const imgPath = this.createImageFile();

    // 将文件路径转换为文件 URI
    const imgUri = fileUri.getUriFromPath(imgPath);

    // 创建显式 Want 并设置目标组件
    const want: Want = {
      // 设置目标组件
      bundleName: 'com.example.ohwantexample', // 目标应用的包名
      abilityName: 'EntryAbility', // 目标 Ability 的名称
      // 配置被分享文件的读写权限
      flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      // 配置分享应用的隐式拉起规则
      action: 'ohos.want.action.sendData',
      uri: imgUri,
      type: 'image/jpeg',
    };

    // 启动接收方组件
    this.context.startAbility(want).then(() => {
      console.info('启动接收方组件成功');
    }).catch((err: BusinessError) => {
      console.error(`启动接收方组件失败，错误码: ${err.code}, 错误信息: ${err.message}`);
    });
  }

  // 创建 img.jpg 文件，返回文件路径
  private createImageFile(): string | null {
    // 获取应用私有文件目录
    const context = this.context as common.UIAbilityContext;
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

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
