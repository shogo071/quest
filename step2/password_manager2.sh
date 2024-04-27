#!/bin/bash

echo 'パスワードマネージャーへようこそ！'

#Exitが選択されるまで同じ処理を繰り返す
while true; do

  echo '次の選択肢から入力してください(Add Password/Get Password/Exit):'
  read -r select

  #サービスの登録の処理
  if [ "$select" = 'Add Password' ]; then
    echo 'サービス名を入力してください：'
    read -r service

    #同じサービスであった場合、再入力してもらう
    while grep -q "$service" step2/password_step2.txt; do
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
$password" >>step2/password_step2.txt

  #登録されたサービスの表示の処理
  elif [ "$select" = 'Get Password' ]; then
    echo 'サービス名を入力してください：'
    read -r service

    #-qオプションで条件分岐分は表示されない
    if grep -q "$service" step2/password_step2.txt; then
      user=$(grep -A 1 "$service" step2/password_step2.txt | tail -n 1)
      pass=$(grep -A 2 "$service" step2/password_step2.txt | tail -n 1)
      echo "サービス名:$service"
      echo "ユーザー名：$user"
      echo "パスワード：$pass"

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
