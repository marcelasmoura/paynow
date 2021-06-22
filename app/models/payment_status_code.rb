module PaymentStatusCode
  CODES = 
  {
    '01' => 'Pendente de cobrança',
    '05' => 'Cobrança efetivada com sucesso',
    '09' => 'Cobrança recusada por falta de créditos',
    '10' => 'Cobrança recusada por dados incorretos para cobrança',
    '11' => 'Cobrança recusada sem motivo especificado',
  }

  def self.status_code_for_select
      PaymentStatusCode::CODES.map{|code| ["#{code[0]} - #{code[1]}", code[0]]}
    end
end