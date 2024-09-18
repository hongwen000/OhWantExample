@Entry
@Component
struct ImplicitIntentIndex {
  @State message: string = 'This is Implicit Want Index';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}