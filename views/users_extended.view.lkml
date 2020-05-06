view: users_extended {
  sql_table_name: public.users ;;
  suggestions: yes


  dimension: name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

   dimension: zip {
    type: number
  }
}
