#!/bin/bash

echo 'パスワードマネージャーへようこそ！'

#Exitが選択されるまで同じ処理を繰り返す
while true; do

  echo '次の選択肢から入力してください(Add Password/Get Password/Exit):'
  read -r select

  #サービスの登録の処理
  if [ "$select" = 'Add Password' ]; then

    #ファイルを暗号化する前に暗号化されたファイルを復号化し新しくパスワードを追加できるようにする
    if [ -f "step3/password_step3.txt.gpg" ]; then
      encrypted_file="step3/password_step3.txt.gpg"
      # ファイルを復号化する
      gpg -d -q --decrypt "$encrypted_file" >output.txt
      cat output.txt >step3/password_step3.txt
      rm output.txt
    fi

    echo 'サービス名を入力してください：'
    read -r service

    #同じサービスであった場合、再入力してもらう
    while grep -q "$service" step3/password_step3.txt; do
      echo "既に登録されたサービスです。再入力してください"
      read -r service
    done

    echo 'ユーザー名を入力してください：'
    read -r user
    echo 'パスワードを入力してください：'
    read -r password
    echo 'Thank you!'

    #保存されたデータを抽出しやすいように改行して保存
    echo "$service
$user
$password" >>step3/password_step3.txt

    #ファイルを暗号化する
    encrypt_file="step3/password_step3.txt"
    gnugp_key="donf8323@gmail.com"
    gpg --yes --recipient "$gnugp_key" --encrypt "$encrypt_file"
    rm step3/password_step3.txt

  #登録されたサービスの表示の処理
  elif [ "$select" = 'Get Password' ]; then
    echo 'サービス名を入力してください：'
    read -r service

    #暗号化されたファイルを復号化する
    encrypted_file="step3/password_step3.txt.gpg"
    # ファイルを復号化する
    gpg -d -q --decrypt "$encrypted_file" >output.txt
    cat output.txt >step3/password_step3.txt
    rm output.txt

    #-qオプションで条件分岐分は表示されない
    if grep -q "$service" step3/password_step3.txt; then
      user=$(grep -A 1 "$service" step3/password_step3.txt | tail -n 1)
      pass=$(grep -A 2 "$service" step3/password_step3.txt | tail -n 1)
      echo "サービス名:$service"
      echo "ユーザー名：$user"
      echo "パスワード：$pass"
      rm step3/password_step3.txt

    else
      echo 'そのサービスは登録されていません。'
    fi

  #Exitの処理
  elif [ "$select" = 'Exit' ]; then
    echo 'Thank you!'
    break

  #Add Password/Get Password/Exit 以外が入力された場合
  else
    echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
  fi

done
