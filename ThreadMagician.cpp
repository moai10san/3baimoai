 class Magician{
   private:
       const int kMAX_MP = 100;
       int m_MP;
       int m_magicAttack;
   public:
       //コンストラクタ
       explicit Magician(int MP): m_MP(MP), m_magicAttack(300){}
       void FinalExplosion(){
           //MPをすべて消費して最強攻撃を仕掛ける
           //ただしMPが最大MPの半分以下であるときは実行できない
           if (m_MP >= kMAX_MP /2)
           {
               int finalAttack = m_MP * m_magicAttack * 1000; //なんか複雑な計算をほんとは走らせたい
               std::cout << "魔法使いはすべての力をふりしぼった!!" <<std::endl;
               std::cout << finalAttack << "のダメージ!!!" << std::endl;
               m_MP = 0;
               std::cout << "魔法使いのMPは0になった..." <<std::endl;
           }
           else{
           std::cout << "魔法使いのMPが足りない!!" <<std::endl;
           }
       }
   };
   
   int main (int argc, char *argv[]) {
          try {
                  Magician magician{100};
                  std::thread t1(&Magician::FinalExplosion,&magician);
                  std::cout << "処理待つ"<< std::endl;
                  t1.join();
                  
                  Magician magician2{40};
                  std::thread t2(&Magician::FinalExplosion,&magician2);
                  std::cout << "処理待つ"<< std::endl;
                  t2.join();
                  
                  //ラムダ式を使ってメンバ関数を指定する場合
                  //参照キャプチャする
                  std::thread t3([&magician]{magician.FinalExplosion();});
                  std::cout << "処理待つ"<< std::endl;
                  t3.join();
                  
          } catch (std::exception &ex) {
                  std::cerr << ex.what() << std::endl;
          }
          return (0);
  }
