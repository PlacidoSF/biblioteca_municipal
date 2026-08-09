class RelatorioAtrasosPdf < Prawn::Document
  def initialize(emprestimos)
    super(page_size: "A4", margin: 40)
  
    @emprestimos = emprestimos.select { |e| e.status_dinamico == 'Atrasado' }

    cabecalho
    espacamento
    tabela_de_dados
    rodape
  end

  def cabecalho
    text "Biblioteca Municipal Ney Pontes", size: 24, style: :bold, align: :center
    text "Relatório de Livros em Atraso", size: 16, style: :italic, align: :center
    move_down 10
    text "Gerado em: #{Time.current.strftime('%d/%m/%Y às %H:%M')}", size: 10, align: :right, color: "777777"
  end

  def espacamento
    move_down 30
  end

  def tabela_de_dados
    if @emprestimos.empty?
      text "Excelente notícia! Não há nenhum livro em atraso no momento.", size: 14, align: :center, color: "00b300"
      return
    end

    dados = [["Leitor", "Livro", "Empréstimo", "Vencimento", "Dias de Atraso", "Multa (R$)"]]

    @emprestimos.each do |e|
      dias_atrasados = (Date.current - e.data_devolucao_prevista).to_i

      dados << [
        e.usuario.nome,
        e.livro.titulo,
        e.data_emprestimo.strftime("%d/%m/%Y"),
        e.data_devolucao_prevista.strftime("%d/%m/%Y"),
        "#{dias_atrasados} dias",
        "R$ #{'%.2f' % e.valor_multa}"
      ]
    end

    table(dados, header: true, width: bounds.width) do
      row(0).font_style = :bold
      row(0).background_color = "EEEEEE"
      row(0).align = :center
      
      column(2..4).align = :center
      
      column(5).align = :right
      
      columns(4..5).text_color = "CC0000"
      
      row(0).text_color = "000000" 
    end
  end

  def rodape
    move_down 40
    text "Prefeitura de Mossoró/RN", size: 10, align: :center, color: "999999"
  end
end
