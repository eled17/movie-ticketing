from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

import models, schemas, crud
from database import SessionLocal, engine

# models.Base.metadata.drop_all(bind=engine)
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# DB session dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow all origins for testing
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/movies", response_model=schemas.Movie)
def add_movie(movie: schemas.MovieCreate, db: Session = Depends(get_db)):
    return crud.create_movie(db, movie)

@app.get("/movies", response_model=list[schemas.Movie])
def list_movies(db: Session = Depends(get_db)):
    return crud.get_movies(db)

@app.post("/showtimes", response_model=schemas.Showtime)
def add_showtime(showtime: schemas.ShowtimeCreate, db: Session = Depends(get_db)):
    return crud.create_showtime(db, showtime)

@app.get("/showtimes", response_model=list[schemas.Showtime])
def list_showtimes(db: Session = Depends(get_db)):
    return crud.get_showtimes(db)

@app.post("/tickets", response_model=schemas.Ticket)
def book_ticket(ticket: schemas.TicketCreate, db: Session = Depends(get_db)):
    return crud.book_ticket(db, ticket)

@app.get("/tickets", response_model=list[schemas.Ticket])
def get_tickets(db: Session = Depends(get_db)):
    return crud.get_tickets(db)

@app.get("/tickets/{showtime_id}")
def read_tickets(showtime_id: int, db: Session = Depends(get_db)):
    tickets = crud.get_tickets_by_showtime(db, showtime_id)
    return [{"seat_number": t.seat_number} for t in tickets]

@app.get("/tickets/user/{user_id}", response_model=list[schemas.Ticket])
def get_tickets_by_user(user_id: int, db: Session = Depends(get_db)):
    return crud.get_tickets_by_user(db, user_id)

@app.post("/register", response_model=schemas.User)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    return crud.create_user(db, user.email, user.password)

@app.post("/login")
def login_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user.email, user.password)
    if not db_user:
        return {"error": "Invalid credentials"}
    return {"user_id": db_user.id, "email": db_user.email}

@app.get("/tickets/user/{user_id}", response_model=list[schemas.Ticket])
def get_user_tickets(user_id: int, db: Session = Depends(get_db)):
    tickets = db.query(models.Ticket).filter(models.Ticket.user_id == user_id).all()
    return tickets




