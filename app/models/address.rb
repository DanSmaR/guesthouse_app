class Address < ApplicationRecord
  enum state: {
    'são paulo': 'SP', 'rio de janeiro': 'RJ', 'minas gerais': 'MG', 'bahia': 'BA',
    'paraná': 'PR', 'rio grande do sul': 'RS', 'pernambuco': 'PE', 'ceará': 'CE',
    'pará': 'PA', 'santa catarina': 'SC', 'maranhão': 'MA', 'goiás': 'GO',
    'espírito santo': 'ES', 'paraíba': 'PB', 'amazonas': 'AM', 'rio grande do norte': 'RN',
    'mato grosso': 'MT', 'alagoas': 'AL', 'piauí': 'PI', 'distrito federal': 'DF',
    'mato grosso do sul': 'MS', 'sergipe': 'SE', 'rondônia': 'RO', 'tocantins': 'TO',
    'acre': 'AC', 'amapá': 'AP', 'roraima': 'RR'
  }
  has_one :guesthouse
end
